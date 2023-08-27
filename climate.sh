#! /usr/bin/env nix-shell
#! nix-shell --pure -i dash -I channel:nixos-23.05-small -p cacert curl jq nix
set -eu

# Usage: ./charging.sh

. ./skoda_env.sh

token=$(./skoda_login.sh 2)
curl -s -H "Authorization: Bearer $token" https://api.connect.skoda-auto.cz/api/v1/air-conditioning/${SKODA_VIN}/status | jq