#! /usr/bin/env nix-shell
#! nix-shell --pure --keep EMAIL --keep PASSWORD --keep VIN -i bash -I channel:nixos-22.11-small -p jq nix
set -eu

# Usage: EMAIL=foo@example.com PASSWORD=mypass VIN=T1234567891011121 ./get_batteryPercentage.sh

./get_charging.sh | jq '.secondaryEngineConnectRange / .secondaryEngineMaximalRange'