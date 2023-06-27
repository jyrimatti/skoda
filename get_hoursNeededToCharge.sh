#! /usr/bin/env nix-shell
#! nix-shell --pure --keep EMAIL --keep PASSWORD --keep VIN --keep CAPACITY_KWH --keep POWER_KW -i bash -I channel:nixos-22.11-small -p bc nix
set -eu

# Usage: EMAIL=foo@example.com PASSWORD=mypass VIN=T1234567891011121 CAPACITY_KWH=13 POWER_KW=2.3 ./get_hoursNeededToCharge.sh

batteryPercentage=$(./get_batteryPercentage.sh)

echo "$batteryPercentage * $CAPACITY_KWH / $POWER_KW" | bc -l