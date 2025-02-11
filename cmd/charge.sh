#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p cacert curl yq htmlq jq nix dash bkt flock
set -eu

getset="${1:-}"
value="${4:-}"
if [ "$value" = "true" ] || [ "$value" = "1" ]; then
  value="Start";
else
  value="Stop";
fi

. ./skoda_env.sh

if [ "$getset" = "Set" ]; then
    token="$(dash ./skoda_login.sh 2)"
    curl -s -H "Authorization: Bearer $token" -H 'Content-Type: application/json' https://api.connect.skoda-auto.cz/api/v1/charging/operation-requests?vin=${SKODA_VIN} -d "{\"type\": \"$value\"}" | jq '.status'
else
    ret="$(dash ./charging.sh | jq -r '.charging.state')"
    if [ "$ret" = "Charging" ]; then
        echo 1
    elif [ "$ret" = "ReadyForCharging" ]; then
        echo 0
    else
        echo "Unexpected response: $ret" >&2
        echo 0
    fi
fi
