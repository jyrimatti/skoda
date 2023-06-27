#! /usr/bin/env nix-shell
#! nix-shell --pure --keep EMAIL --keep PASSWORD --keep VIN -i bash -I channel:nixos-22.11-small -p cacert curl jq nix
set -eu

# Usage: EMAIL=foo@example.com PASSWORD=mypass VIN=T1234567891011121 ./get_charging.sh

token=$(./login.sh)
curl -s -H "Authorization: Bearer $token" https://api.skoda-connect.com/vehicles/$VIN/services/rvs | jq