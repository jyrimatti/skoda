#! /usr/bin/env nix-shell
#! nix-shell --pure -i bash -I channel:nixos-23.05-small -p cacert curl jq nix
set -eu

getset=${1:-}
value=${4:-}
if [ "$value" == "true" ] || [ "$value" == "1" ]; then
  value="start";
else
  value="stop";
fi

source ./skoda_env.sh

token=$(./skoda_login.sh 2)

if [ "$getset" == "Set" ]; then
    curl -s -H "Authorization: Bearer $token" -H 'Content-Type: application/json' https://api.connect.skoda-auto.cz/api/v1/air-conditioning/operation-requests/$value-window-heating -d "{\"vin\": \"$SKODA_VIN\"}" | jq '.status'
else
    ret=$(curl -s -H "Authorization: Bearer $token" https://api.connect.skoda-auto.cz/api/v1/air-conditioning/${SKODA_VIN}/status | jq -r '.windowsHeatingStatuses[].state' | uniq | tr -d '\n')
    if [ "$ret" == "Off" ]; then
        echo 0
    elif [ "$ret" == "On" ] || [ "$ret" == "OnOff" ] || [ "$ret" == "OffOn" ]; then
        echo 1
    else
        echo "$ret"
    fi
fi