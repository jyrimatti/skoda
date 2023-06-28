#! /usr/bin/env nix-shell
#! nix-shell --pure -i bash -I channel:nixos-22.11-small -p bc nix
set -eu

capacity_kwh=$1
power_kw=$2

# Usage: ./hoursNeededToCharge.sh 13 2.3

batteryPercentage=$(./batteryPercentage.sh)

echo "(1 - $batteryPercentage) * $capacity_kwh / $power_kw" | bc -l