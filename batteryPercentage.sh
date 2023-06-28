#! /usr/bin/env nix-shell
#! nix-shell --pure -i bash -I channel:nixos-22.11-small -p jq nix
set -eu

# Usage: ./batteryPercentage.sh

./charging.sh | jq '.secondaryEngineConnectRange / .secondaryEngineMaximalRange'