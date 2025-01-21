#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep XDG_RUNTIME_DIR -i dash -I channel:nixos-24.11-small -p cacert curl jq nix dash
set -eu

# Usage: ./charging.sh

. ./skoda_env.sh

token="$(./skoda_login.sh 2)"
curl -s -H "Authorization: Bearer $token" "https://api.connect.skoda-auto.cz/api/v1/air-conditioning/${SKODA_VIN}/status" | jq