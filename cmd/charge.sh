#! /usr/bin/env nix-shell
#! nix-shell --pure -i dash -I channel:nixos-23.11-small -p cacert curl jq nix dash
set -eu

getset="${1:-}"
value="${4:-}"
if [ "$value" = "true" ] || [ "$value" = "1" ]; then
  value="Start";
else
  value="Stop";
fi

. ./skoda_env.sh

token="$(./skoda_login.sh 2)"

if [ "$getset" = "Set" ]; then
    curl -s -H "Authorization: Bearer $token" -H 'Content-Type: application/json' https://api.connect.skoda-auto.cz/api/v1/charging/operation-requests?vin=${SKODA_VIN} -d "{\"type\": \"$value\"}" | jq '.status'
else
    ret="$(curl -s -H "Authorization: Bearer $token" https://api.connect.skoda-auto.cz/api/v1/charging/${SKODA_VIN}/status | jq -r '.charging.state')"
    if [ "$ret" = "Charging" ]; then
        echo 1
    elif [ "$ret" = "ReadyForCharging" ]; then
        echo 0
    else
        echo "Unexpected response: $ret" >&2
        echo 0
    fi
fi
