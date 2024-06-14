#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep XDG_RUNTIME_DIR -i dash -I channel:nixos-23.11-small -p jq nix bc dash
set -eu

# Usage: ./secondsRemainingToCharge.sh

echo "$(./charging.sh | jq '.charging.remainingToCompleteInSeconds') + 0.1" | bc
