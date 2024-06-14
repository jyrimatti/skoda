#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep XDG_RUNTIME_DIR -i dash -I channel:nixos-23.11-small -p jq nix dash
set -eu

# Usage: ./lowBattery.sh

test "$(./cmd/batteryPercentage.sh $*)" -lt 50 && echo 1 || echo 0
