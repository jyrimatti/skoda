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
    settings="$(curl -s -H "Authorization: Bearer $token" https://api.connect.skoda-auto.cz/api/v1/air-conditioning/${SKODA_VIN}/settings)"
    curl -s -H "Authorization: Bearer $token" -H 'Content-Type: application/json' https://api.connect.skoda-auto.cz/api/v1/air-conditioning/operation-requests?vin=${SKODA_VIN} -d "{\"type\": \"$value\", \"airConditioningSettings\": $settings}" | jq '.status'
else
    ret="$(dash ./climate.sh | jq -r '.state')"
    if [ "$ret" = "Off" ]; then
        echo 0
    elif [ "$ret" = "Heating" ]; then
        echo 1
    else
        echo "$ret"
    fi
fi
