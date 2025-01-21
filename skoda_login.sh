#! /usr/bin/env nix-shell
#! nix-shell --pure --keep XDG_RUNTIME_DIR --keep SKODA_USER --keep SKODA_PASSWORD -i dash -I channel:nixos-24.11-small -p dash cacert curl jq yq htmlq flock gnugrep gnused findutils
set -eu

# Usage: SKODA_USER=foo@example.com SKODA_PASSWORD=mypass ./skoda_login.sh <1|2>

endpoint=$1

test -e "${XDG_RUNTIME_DIR:-/tmp}/skoda" || mkdir -p "${XDG_RUNTIME_DIR:-/tmp}/skoda"

flock "${XDG_RUNTIME_DIR:-/tmp}/skoda/lock-$endpoint" ./skoda_login_actual.sh "$endpoint"