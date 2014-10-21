#!/usr/bin/env bash

# Enable POSIX compatibility mode for portability.
set -o posix

# Treat unset variables and parameters
# other than the special parameters "@" and "*"
# as an error when performing parameter expansion.
set -o nounset

# Terminate as soon as any command fails.
set -o errexit

# Don't overwrite an existing file.
set -o noclobber

symlink_to_txt () {
  local TARGET=$(readlink -- "$*")
  rm -- "$*"
  printf %s "$TARGET" > "$*"
}

txt_to_symlink() {
  # Store file contents in the $TARGET variable.
  local TARGET=$(<"$*")
  # Check to see if the file contents are a valid path.
  if [ -e "$TARGET" ]; then
    rm -- "$*"
    ln --symbolic -- "$TARGET" "$*"
  else
    echo "\`$TARGET\` is not a valid target for a symbolic link."
    exit 2
  fi
}

# If the input file exists and is a symbolic link,
# we want to turn it into a text file with the same name.
if [ -L "$*" ]; then
  symlink_to_txt "$*"
# However, if the input is a regular file with a non-zero size,
# we want to turn it into a symbolic link to wherever its contents point.
elif [ -f "$*" -a -s "$*" ]; then
  txt_to_symlink "$*"
else
  echo "\`$*\` is not an symbolic link or regular file."
  exit 1
fi

#DONE: use `printf` instead of `echo`
#DONE: terminate options to readlink
#TODO: check for broken symbolic links. Or maybe they should just be transformed normally?
#TODO: check permissions.
#TODO: preserve permissions?
#TODO: preserve modification time?
#TODO: check for race conditions?
