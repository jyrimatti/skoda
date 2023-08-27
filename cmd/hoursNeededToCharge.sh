#! /usr/bin/env nix-shell
#! nix-shell --pure -i dash -I channel:nixos-23.05-small -p bc nix dash getoptions
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

CAPACITY_KWH=$1

batteryPercentage=$(./cmd/batteryPercentage.sh)

echo "(100 - $batteryPercentage)/100 * $CAPACITY_KWH / $POWER_KW" | bc -l