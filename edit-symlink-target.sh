#!/usr/bin/env bash

if test "$#" -eq 0
then
    printf 'Usage: %s name-of-symlink\n' "$0"
    exit 1
fi

if ! type toggle-symlink.sh > /dev/null
then
    printf 'Cannot find toggle-symlink.sh in $PATH\n' >&2
    exit 1
fi

for symlink in "$@"
do
    toggle-symlink.sh "$symlink"
    editor "$symlink"
    toggle-symlink.sh "$symlink"
done
