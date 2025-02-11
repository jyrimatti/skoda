#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p jq nix bc dash bkt
set -eu

# Usage: ./secondsRemainingToCharge.sh

echo "$(dash ./charging.sh | jq '.charging.remainingToCompleteInSeconds') + 0.1" | bc
