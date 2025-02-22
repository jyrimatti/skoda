#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p bc nix dash getoptions bkt flock curl cacert yq htmlq
set -eu

POWER_KW=2.3

parser() {
  msg -- "Calculates hours needed to charge the battery to full capacity" ''
  setup   REST error:usage help:usage -- "Usage:  $0 [options]... <battery capacity kWh>" ''
  msg -- 'Options:'
  param   POWER_KW  -p --power init:=$POWER_KW validate:number -- "Charging power in kW (default: $POWER_KW)"
  disp    :usage    -h --help
}
number() { case $OPTARG in (*[!0-9.]*) return 1; esac; }
eval "$(getoptions parser) exit 1"

if [ $# = 0 ]; then usage; exit 1; fi

CAPACITY_KWH="$1"

batteryPercentage="$(dash ./cmd/batteryPercentage.sh)"

printf %.1f "$(echo "(100 - $batteryPercentage)/100 * $CAPACITY_KWH / $POWER_KW" | bc -l)"