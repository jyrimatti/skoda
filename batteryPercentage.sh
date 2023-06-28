#! /usr/bin/env nix-shell
#! nix-shell --pure -i bash -I channel:nixos-23.05-small -p jq nix
set -eu

# Usage: ./batteryPercentage.sh

./charging.sh | jq '.secondaryEngineConnectRange / .secondaryEngineMaximalRange'