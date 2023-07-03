#! /usr/bin/env nix-shell
#! nix-shell --pure -i bash -I channel:nixos-23.05-small -p jq nix
set -eu

# Usage: ./secondsRemainingToCharge.sh

./charging.sh | jq '.charging.remainingToCompleteInSeconds'