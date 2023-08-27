#! /usr/bin/env nix-shell
#! nix-shell --pure -i dash -I channel:nixos-23.05-small -p cacert curl jq nix
set -eu

# Usage: ./charging.sh

. ./skoda_env.sh

token=$(./skoda_login.sh 1)
curl -s -H "Authorization: Bearer $token" https://api.skoda-connect.com/vehicles/${SKODA_VIN}/services/rvs | jq