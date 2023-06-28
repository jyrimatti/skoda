#! /usr/bin/env nix-shell
#! nix-shell --pure -i bash -I channel:nixos-22.11-small -p cacert curl jq nix
set -eu

# Usage: ./charging.sh

source ./skoda_env.sh

token=$(./skoda_login.sh)
curl -s -H "Authorization: Bearer $token" https://api.skoda-connect.com/vehicles/${SKODA_VIN}/services/rvs | jq