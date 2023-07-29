#! /usr/bin/env nix-shell
#! nix-shell --pure --keep SKODA_USER --keep SKODA_PASSWORD -i bash -I channel:nixos-23.05-small -p bash cacert curl jq yq htmlq flock gnugrep gnused
set -eu

# Usage: SKODA_USER=foo@example.com SKODA_PASSWORD=mypass ./skoda_login.sh <1|2>

endpoint=$1

mkdir -p "/tmp/skoda-$USER"

flock "/tmp/skoda-$USER/lock-$endpoint" ./skoda_login_actual.sh "$endpoint"