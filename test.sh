#!/usr/bin/env bash

# Treat unset variables and parameters
# other than the special parameters "@" and "*"
# as an error when performing parameter expansion.
set -o nounset

# Terminate as soon as any command fails.
set -o errexit

DIR="$(mktemp --directory)"

printf 'This is not a valid symlink path.' > "$DIR/file.txt"

# Make relative links.
ln -s -- file.txt "$DIR/relative link to file.txt"
ln -s -- 'relative link to file.txt' "$DIR/relative link to relative link to file.txt"

# Make an abolute link.
ln -s -- "$DIR/file.txt" "$DIR/absolute link to file.txt"

function test_toggle {
    local LINK="$*"
    if ! test -L "$LINK"
    then
        printf 'Error: not a symbolic link: %s\n' "$LINK"
        return 1
    fi
    local BEFORE="$(file "$LINK")"
    ./toggle-symlink.sh "$LINK"
    ./toggle-symlink.sh "$LINK"
    local AFTER="$(file "$LINK")"
    if ! test "$AFTER" = "$BEFORE"
    then
        printf 'Error: toggle-symlink.sh altered link.\n'
        printf 'Before: %s\n' "$BEFORE"
        printf 'After : %s\n' "$AFTER"
        return 1
    else
        return 0
    fi
}

# Test the toggling capability of each one.
test_toggle "$DIR/relative link to file.txt"

test_toggle "$DIR/absolute link to file.txt"

test_toggle "$DIR/relative link to relative link to file.txt"

# Toggle them all at once.
./toggle-symlink.sh \
    "$DIR"/'relative link to file.txt'\
    "$DIR"/'absolute link to file.txt' \
    "$DIR"/'relative link to relative link to file.txt'

./toggle-symlink.sh \
    "$DIR"/'relative link to file.txt' \
    "$DIR"/'absolute link to file.txt' \
    "$DIR"/'relative link to relative link to file.txt'
