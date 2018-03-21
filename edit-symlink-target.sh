#!/usr/bin/env bash

if test "$#" -eq 0
then
    printf 'Usage: %s name-of-symlink\n' "$0"
    exit 1
fi

toggle-symlink.sh "$*"
editor "$*"
toggle-symlink.sh "$*"
