#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p jq nix dash bkt flock curl cacert yq htmlq
set -eu

# Usage: ./lowBattery.sh

test "$(dash ./cmd/batteryPercentage.sh $*)" -lt 50 && echo 1 || echo 0
