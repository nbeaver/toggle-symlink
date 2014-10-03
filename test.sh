#!/usr/bin/env bash
chmod +x toggle-symlink.sh
mkdir -p example-symlinks/
echo "This is not a valid symlink path." > example-symlinks/file.txt
# Make relative links.
cd example-symlinks/
ln --symbolic --force file.txt 'relative link to file.txt'
ln --symbolic --force file.txt '*'
#ln --symbolic --force file.txt '--force *'
cd -
# Make an abolute link.
ln --symbolic --force "$PWD/example-symlinks/file.txt" "$PWD/example-symlinks/absolute link to file.txt"
# Test the toggling capability of each one.
cd example-symlinks/
../toggle-symlink.sh 'relative link to file.txt'
../toggle-symlink.sh 'relative link to file.txt'
../toggle-symlink.sh '*'
../toggle-symlink.sh '*'
#../toggle-symlink.sh '--force *'
#../toggle-symlink.sh '--force *'
../toggle-symlink.sh 'absolute link to file.txt'
../toggle-symlink.sh 'absolute link to file.txt'
cd -
