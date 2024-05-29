#! /usr/bin/env nix-shell
#! nix-shell --pure --keep LD_LIBRARY_PATH --keep SKODA_USER --keep SKODA_PASSWORD -i dash -I channel:nixos-23.11-small -p dash cacert curl jq yq htmlq flock gnugrep gnused findutils
set -eu

# Usage: SKODA_USER=foo@example.com SKODA_PASSWORD=mypass ./skoda_login.sh <1|2>

endpoint=$1

test -e "/tmp/skoda-$USER" || mkdir -p "/tmp/skoda-$USER"

flock "/tmp/skoda-$USER/lock-$endpoint" ./skoda_login_actual.sh "$endpoint"