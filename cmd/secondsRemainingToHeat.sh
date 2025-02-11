#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p jq nix bc dash bkt flock curl cacert yq htmlq
set -eu

# Usage: ./secondsRemainingToHeat.sh

echo "$(dash ./climate.sh | jq '.remainingTimeToReachTargetTemperatureInSeconds') + 0.1" | bc