#!/usr/bin/env bash
# Treat unset variables and parameters
# other than the special parameters "@" and "*"
# as an error when performing parameter expansion.
set -o nounset

# Terminate as soon as any command fails.
set -o errexit

DIR="$(mktemp --directory)"
printf 'Temporary directory: %s\n' "$DIR" >&2

printf 'This is not a valid symlink path.' > "$DIR"/'file.txt'

# Make relative links.
ln -s -- file.txt "$DIR/"'relative link to file.txt'
ln -s -- 'relative link to file.txt' "$DIR/"'relative link to relative link to file.txt'

# Make an abolute link.
ln -s -- "$DIR/file.txt" "$DIR/absolute link to file.txt"

# Test the toggling capability of each one.
set -x
./toggle-symlink.sh "$DIR"/'relative link to file.txt'
./toggle-symlink.sh "$DIR"/'relative link to file.txt'

./toggle-symlink.sh "$DIR"/'absolute link to file.txt'
./toggle-symlink.sh "$DIR"/'absolute link to file.txt'

./toggle-symlink.sh "$DIR"/'relative link to relative link to file.txt'
./toggle-symlink.sh "$DIR"/'relative link to relative link to file.txt'

# Toggle them all at once.
./toggle-symlink.sh \
    "$DIR"/'relative link to file.txt'\
    "$DIR"/'absolute link to file.txt' \
    "$DIR"/'relative link to relative link to file.txt'

./toggle-symlink.sh \
    "$DIR"/'relative link to file.txt' \
    "$DIR"/'absolute link to file.txt' \
    "$DIR"/'relative link to relative link to file.txt'
set +x
