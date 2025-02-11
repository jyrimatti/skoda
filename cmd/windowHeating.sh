#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p coreutils cacert curl yq htmlq jq nix dash bkt flock
set -eu

getset="${1:-}"
value="${4:-}"
if [ "$value" = "true" ] || [ "$value" = "1" ]; then
  value="start";
else
  value="stop";
fi

. ./skoda_env.sh

if [ "$getset" = "Set" ]; then
    token="$(dash ./skoda_login.sh 2)"
    curl -s -H "Authorization: Bearer $token" -H 'Content-Type: application/json' https://api.connect.skoda-auto.cz/api/v1/air-conditioning/operation-requests/$value-window-heating -d "{\"vin\": \"$SKODA_VIN\"}" | jq '.status'
else
    ret="$(dash ./climate.sh | jq -r '.windowsHeatingStatuses[].state' | uniq | tr -d '\n')"
    if [ "$ret" = "Off" ]; then
        echo 0
    elif [ "$ret" = "On" ] || [ "$ret" = "OnOff" ] || [ "$ret" = "OffOn" ]; then
        echo 1
    else
        echo "$ret"
    fi
fi
