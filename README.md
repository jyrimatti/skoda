# skoda
Scripts to read/manage some Skoda cars

Feel free to use and modify these as you will. Please let me know of any improvements you make for yourself.

Functionality
=============
- read individual values
- write individual commands
- directly usable with [homebridge](https://homebridge.io)

Prerequisites
=============
- get a computer (e.g. a virtual server or a Raspberry Pi)
- install Nix (or manually all the things used in scripts)
- install homebridge & plugins
  - `npm install -g --unsafe-perm homebridge`
  - `npm install -g --unsafe-perm homebridge-cmd4`

Setup
=====
Assuming user home directory
```
cd ~
```

Clone this repo
```
git clone https://github.com/jyrimatti/skoda.git
```

Store Skoda credentials
```
echo '<my skoda user>' > .skoda-user
echo '<my skoda password>' > .skoda-pass
echo '<my skoda VIN>' > .skoda-vin
chmod go-rwx .skoda*
```

[Setup Homebridge](#homebridge-configuration)

~~profit!~~

Dependencies
============

Just install Nix, it handles all the dependencies for you.

However, constantly running nix-shell has a lot of overhead, so you might want to install all the required dependencies globally, and bypass nix-shell when executing scripts from within other processes (cron, cgi, homebridge...):

For example, installing with Nix:
```
> nix-env -f https://github.com/NixOS/nixpkgs/archive/nixos-23.05-small.tar.gz -i curl jq yq htmlq bc getoptions
```

Then create somewhere a symlink named `nix-shell` pointing to just the regular shell:
```
> mkdir ~/.local/nix-override
> ln -s /bin/sh ~/.local/nix-override/nix-shell
```

after which you can override nix-shell with PATH:
```
PATH=~/.local/nix-override:$PATH ./current.sh
```

Homebridge configuration
========================

You can use these scripts with Homebridge to show and modify values with Apple HomeKit. Example configuration:
```
{
    "bridge": {
        "name": "Homebridge",
        "username": "11:22:33:44:55:66",
        "port": 51826,
        "pin": "123-45-678"
    },
    "description": "",
    "accessories": [],
    "platforms": [
    {
         "platform": "Cmd4",
         "name": "Cmd4",
         "outputConstants": false,
         "_bridge": {
            "username": "AA:AA:AA:AA:AA:27",
            "port": 51827
         },
         "interval": 600,
         "timeout": 10000,
         "accessories" :
         [
            {
               "type":               "BatteryService",
               "name":               "Car battery",
               "displayName":        "Car battery",
               "batteryLevel":       0,
               "chargingState":      "NOT_CHARGING",
               "statusLowBattery":   "BATTERY_LEVEL_NORMAL",
               "state_cmd":          ". /etc/profile; /home/pi/skoda/batteryPercentage.sh"
            },
            {
               "type":        "Switch",
               "name":        "Charge",
               "displayName": "Charge",
               "state_cmd":   ". /etc/profile; /home/pi/skoda/charge.sh"
            },
            {
               "type":        "Switch",
               "name":        "Clima",
               "displayName": "Clima",
               "state_cmd":   ". /etc/profile; /home/pi/skoda/clima.sh"
            },
            {
               "type":        "Switch",
               "name":        "Window heating",
               "displayName": "Window heating",
               "state_cmd":   ". /etc/profile; /home/pi/skoda/windowHeating.sh"
            },
            {
               "type":                    "TemperatureSensor",
               "name":                    "Second remaining to charge",
               "displayName":             "Second remaining to charge",
               "statusActive":            "TRUE",
               "currentTemperature":      66.6,
               "state_cmd":               ". /etc/profile; /home/pi/skoda/secondRemainingToCharge.sh"
            },
            {
               "type":                    "TemperatureSensor",
               "name":                    "Second remaining to heat",
               "displayName":             "Second remaining to heat",
               "statusActive":            "TRUE",
               "currentTemperature":      66.6,
               "state_cmd":               ". /etc/profile; /home/pi/skoda/secondRemainingToHeat.sh"
            },
            {
               "type":                    "TemperatureSensor",
               "name":                    "Hours needed to charge",
               "displayName":             "Hours needed to charge",
               "statusActive":            "TRUE",
               "currentTemperature":      66.6,
               "state_cmd":               ". /etc/profile; /home/pi/skoda/hoursNeededToCharge.sh"
            }
        ]
    }
    ]
}
```

Standing on the shoulders of
============================
- [curl](https://curl.se)
- [websocat](https://github.com/vi/websocat)
- [getoptions](https://github.com/ko1nksm/getoptions)
- [jq](https://stedolan.github.io/jq/)
- [yq](https://github.com/kislyuk/yq)
- [htmlq](https://github.com/mgdm/htmlq)
- [SQLite](https://www.sqlite.org/index.html)
- [sql.js-httpvfs](https://github.com/phiresky/sql.js-httpvfs)
- [jquery](https://jquery.com)
- [flot](http://www.flotcharts.org)
- [homebridge](https://homebridge.io)
- [cmd4](https://github.com/ztalbot2000/homebridge-cmd4)