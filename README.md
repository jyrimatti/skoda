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
PATH=~/.local/nix-override:$PATH ./charging.sh
```

Homebridge configuration
========================

You can use these scripts with Homebridge to show and modify values with Apple HomeKit.

See [example configuration](homebridge/config.json).

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