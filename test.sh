#!/usr/bin/env bash
# Treat unset variables and parameters
# other than the special parameters "@" and "*"
# as an error when performing parameter expansion.
set -o nounset

# Terminate as soon as any command fails.
set -o errexit

mkdir -p example-symlinks/
echo "This is not a valid symlink path." > example-symlinks/file.txt
# Make relative links.
cd example-symlinks/
ln --symbolic --force --no-target-directory -- file.txt 'relative link to file.txt'
ln --symbolic --force --no-target-directory -- 'relative link to file.txt' 'relative link to relative link to file.txt'
cd -
# Make an abolute link.
ln --symbolic --force -- "$PWD/example-symlinks/file.txt" "$PWD/example-symlinks/absolute link to file.txt"
# Test the toggling capability of each one.
cd example-symlinks/
../toggle-symlink.sh 'relative link to file.txt'
../toggle-symlink.sh 'relative link to file.txt'
../toggle-symlink.sh 'absolute link to file.txt'
../toggle-symlink.sh 'absolute link to file.txt'
../toggle-symlink.sh 'relative link to relative link to file.txt'
../toggle-symlink.sh 'relative link to relative link to file.txt'
file -- *
# Toggle them all at once.
../toggle-symlink.sh 'relative link to file.txt' 'absolute link to file.txt' 'relative link to relative link to file.txt'
../toggle-symlink.sh 'relative link to file.txt' 'absolute link to file.txt' 'relative link to relative link to file.txt'
file -- *
cd -
