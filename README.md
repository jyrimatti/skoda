# Homekit.sh plugin for Skoda cars

Prerequisites
-------------
- get a computer (e.g. a server or a Raspberry Pi)
- install [Nix](https://nixos.org/download/)
- install [Homekit.sh](https://github.com/jyrimatti/homekit.sh)

Setup for home automation
-------------------------

```
cd ~/.config/homekit.sh/accessories
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
