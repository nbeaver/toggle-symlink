#!/usr/bin/env bash

if test -z "$*"
then
    printf "Usage: edit-symlink-target name-of-symlink\n"
    return 1
else
    toggle-symlink.sh "$*"
    editor "$*"
    toggle-symlink.sh "$*"
fi
