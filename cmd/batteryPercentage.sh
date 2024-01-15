#! /usr/bin/env nix-shell
#! nix-shell --pure -i dash -I channel:nixos-23.11-small -p jq nix dash
set -eu

# Usage: ./batteryPercentage.sh

characteristic=${3:-"BatteryLevel"}

if [ "$characteristic" = "BatteryLevel" ]; then
  ./charging.sh | jq '.battery.stateOfChargeInPercent'
elif [ "$characteristic" = "StatusLowBattery" ]; then
  res=$(./charging.sh | jq '.battery.stateOfChargeInPercent')
  if [ "$res" -lt 30 ]; then
    echo 1
  else
    echo 0
  fi
elif [ "$characteristic" = "ChargingState" ]; then
  res=$(./charging.sh | jq -r '.charging.state')
  if [ "$res" = "ReadyForCharging" ]; then
    echo 0
  elif [ "$res" = "Charging" ]; then
    echo 1
  else
    echo "Unknown charging state: $res" >&2
    exit 1
  fi
else
    echo "Unknown characteristic: $characteristic" >&2
    exit 1
fi
