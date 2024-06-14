#!/bin/sh

export SKODA_USER="$(cat "${CREDENTIALS_DIRECTORY:-.}/.skoda-user")"
export SKODA_PASSWORD="$(cat "${CREDENTIALS_DIRECTORY:-.}/.skoda-pass")"
export SKODA_VIN="$(cat "${CREDENTIALS_DIRECTORY:-.}/.skoda-vin")"
