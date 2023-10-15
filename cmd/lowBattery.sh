#! /usr/bin/env nix-shell
#! nix-shell --pure -i dash -I channel:nixos-23.05-small -p jq nix dash
set -eu

# Usage: ./lowBattery.sh

test "$(./cmd/batteryPercentage.sh $*)" -lt 50 && echo 1 || echo 0
