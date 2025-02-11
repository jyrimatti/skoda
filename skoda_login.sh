#! /usr/bin/env nix-shell
#! nix-shell --pure --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p dash cacert curl jq yq htmlq flock gnugrep gnused findutils bkt
set -eu

# Usage: ./skoda_login.sh <1|2>

endpoint="$1"

lock="${BKT_CACHE_DIR:-/tmp}/skoda-login.lock"

flock "$lock" \
    bkt --discard-failures --ttl 5m --stale 4m -- \
        dash ./skoda_login_actual.sh "$endpoint"