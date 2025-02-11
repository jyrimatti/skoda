#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p curl cacert yq htmlq jq nix dash bkt flock
set -eu

# Usage: ./batteryPercentage.sh

characteristic="${3:-BatteryLevel}"

if [ "$characteristic" = "BatteryLevel" ]; then
  dash ./charging.sh | jq '.battery.stateOfChargeInPercent'
elif [ "$characteristic" = "StatusLowBattery" ]; then
  res="$(dash ./charging.sh | jq '.battery.stateOfChargeInPercent')"
  if [ "$res" -lt 30 ]; then
    echo 1
  else
    echo 0
  fi
elif [ "$characteristic" = "ChargingState" ]; then
  res="$(dash ./charging.sh | jq -r '.charging.state')"
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
