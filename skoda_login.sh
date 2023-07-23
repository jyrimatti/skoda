#! /usr/bin/env nix-shell
#! nix-shell --pure --keep SKODA_USER --keep SKODA_PASSWORD -i bash -I channel:nixos-23.05-small -p bash cacert curl jq yq htmlq
set -eu

# Usage: SKODA_USER=foo@example.com SKODA_PASSWORD=mypass ./skoda_login.sh <1|2>

endpoint=$1

if [ "$endpoint" == "1" ]; then
    CLIENT_ID="d2d5cfa4-fdeb-44cb-a621-853c649748ad%40apps_vw-dilab_com"
    REDIRECT="https%3A%2F%2Fwww.skoda-connect.com%2Fwrapper-callback"
    SCOPE="openid%20mbb"
elif [ "$endpoint" == "2" ]; then
    CLIENT_ID="7f045eee-7003-4379-9968-9355ed2adb06@apps_vw-dilab_com"
    REDIRECT="skodaconnect%3A%2F%2Foidc.login%2F"
    SCOPE="openid%20profile%20address%20cars%20email%20birthdate%20badge%20mbb%20phone%20driversLicense%20dealers%20profession%20vin%20mileage"
fi

authorize() {
    echo '<root>'
    curl -Ls --cookie-jar "/tmp/skoda-cookies-$endpoint.txt" "https://identity.vwgroup.io/oidc/v1/authorize?client_id=${CLIENT_ID}&redirect_uri=$REDIRECT&response_type=code&scope=$SCOPE" | grep 'type="hidden"'
    echo '</root>'
}

login() {
    params=$(authorize | xq -r '.root.input[] | (."@name" + "=" + ."@value")')
    paramsHmac=$(echo "$params" | grep 'hmac' | tr '\n' '&')
    paramsOther=$(echo "$params" | grep -v 'hmac' | tr '\n' '&')

    identifier() {
        curl -Ls -b "/tmp/skoda-cookies-$endpoint.txt" "https://identity.vwgroup.io/signin-service/v1/${CLIENT_ID}/login/identifier" -d "${paramsHmac}${paramsOther}email=${SKODA_USER}" | htmlq --text 'head script' | grep 'templateModel:' | sed 's/^\s*templateModel://' | sed 's/,$//'
    }

    params2=$(identifier | jq -r '.hmac')

    token=$(curl -Ls -b "/tmp/skoda-cookies-$endpoint.txt" -i -D - -o /dev/null "https://identity.vwgroup.io/signin-service/v1/${CLIENT_ID}/login/authenticate" -d "hmac=${params2}&${paramsOther}email=${SKODA_USER}&password=$SKODA_PASSWORD" | grep 'location:' | tail -n1 | sed 's/.*code=\(.*\)/\1/')
    if [ -z "$token" ]; then
        echo "Login failed, trying again" >&2
        token=$(curl -vLs -b "/tmp/skoda-cookies-$endpoint.txt" -i -D - -o /dev/null "https://identity.vwgroup.io/signin-service/v1/${CLIENT_ID}/login/authenticate" -d "hmac=${params2}&${paramsOther}email=${SKODA_USER}&password=$SKODA_PASSWORD" | grep 'location:' | tail -n1 | sed 's/.*code=\(.*\)/\1/')
    fi
    if [ -z "$token" ]; then
        echo "Login failed" >&2
        exit 1
    fi
    echo "$token" > "/tmp/skoda-token-$endpoint"

    rm "/tmp/skoda-cookies-$endpoint.txt"
}

if [ ! -f "/tmp/skoda-token-$endpoint" ]; then
    login
fi
for i in $(find /tmp/skoda-token-"$endpoint" -mmin +5); do
    login
done

cat /tmp/skoda-token-"$endpoint"