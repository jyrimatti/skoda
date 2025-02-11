#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p cacert curl jq nix dash bkt
set -eu

# Usage: ./charging.sh

. ./skoda_env.sh

token="$(dash ./skoda_login.sh 2)"
curl -s -H "Authorization: Bearer $token" "https://api.connect.skoda-auto.cz/api/v1/air-conditioning/${SKODA_VIN}/status" | jq