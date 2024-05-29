#! /usr/bin/env nix-shell
#! nix-shell --pure --keep LD_LIBRARY_PATH -i dash -I channel:nixos-23.11-small -p jq nix bc dash
set -eu

# Usage: ./secondsRemainingToHeat.sh

echo "$(./climate.sh | jq '.remainingTimeToReachTargetTemperatureInSeconds') + 0.1" | bc