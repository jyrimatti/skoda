#! /usr/bin/env nix-shell
#! nix-shell --pure --keep SKODA_USER --keep SKODA_PASSWORD -i bash -I channel:nixos-22.11-small -p bash cacert curl jq yq htmlq
set -eu

# Usage: SKODA_USER=foo@example.com SKODA_PASSWORD=mypass ./skoda_login.sh

CLIENT_ID="d2d5cfa4-fdeb-44cb-a621-853c649748ad%40apps_vw-dilab_com"

authorize() {
    echo '<root>'
    curl -Ls --cookie-jar /tmp/skoda-cookies.txt "https://identity.vwgroup.io/oidc/v1/authorize?client_id=${CLIENT_ID}&redirect_uri=https%3A%2F%2Fwww.skoda-connect.com%2Fwrapper-callback&response_type=code&scope=openid%20mbb" | grep 'type="hidden"'
    echo '</root>'
}

params=$(authorize | xq -r '.root.input[] | (."@name" + "=" + ."@value")')
paramsHmac=$(echo "$params" | grep 'hmac' | tr '\n' '&')
paramsOther=$(echo "$params" | grep -v 'hmac' | tr '\n' '&')

identifier() {
    curl -Ls -b /tmp/skoda-cookies.txt "https://identity.vwgroup.io/signin-service/v1/${CLIENT_ID}/login/identifier" -d "${paramsHmac}${paramsOther}email=${SKODA_USER}" | htmlq --text 'head script' | grep 'templateModel:' | sed 's/^\s*templateModel://' | sed 's/,$//'
}

params2=$(identifier | jq -r '.hmac')

curl -Ls -b /tmp/skoda-cookies.txt -i -D - -o /dev/null "https://identity.vwgroup.io/signin-service/v1/${CLIENT_ID}/login/authenticate" -d "hmac=${params2}&${paramsOther}email=${SKODA_USER}&password=$SKODA_PASSWORD" | grep 'location:' | tail -n1 | sed 's/.*code=\(.*\)/\1/'

rm -f /tmp/skoda-cookies.txt