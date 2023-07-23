#! /usr/bin/env nix-shell
#! nix-shell --pure -i bash -I channel:nixos-23.05-small -p jq nix bc
set -eu

# Usage: ./secondsRemainingToHeat.sh

echo "$(./climate.sh | jq '.remainingTimeToReachTargetTemperatureInSeconds') + 0.1" | bc