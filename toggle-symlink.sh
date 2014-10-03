#!/usr/bin/env bash
# Treat unset variables and parameters
# other than the special parameters "@" and "*"
# as an error when performing parameter expansion.
set -o nounset

# Terminate as soon as any command fails.
set -o errexit

# Don't overwrite an existing file.
set -o noclobber

# If the input file exists and is a symbolic link,
# we want to turn it into a text file with the same name.
if [ -L "$*" ]; then
  TARGET=$(readlink --canonicalize-existing "$*")
  rm -- "$*"
  echo "$TARGET" > "$*"
# However, if the input is a regular file with a non-zero size,
# we want to turn it into a symbolic link to wherever its contents point.
elif [ -f "$*" -a -s "$*" ]; then
  TARGET=$(<"$*")
  # Check to see if the file contents are a valid path.
  if [ -e $TARGET ]; then
    rm -- "$*"
    ln --symbolic -- $TARGET "$*"
  else
    echo "\`$TARGET\` is not a valid target for a symbolic link."
    exit 2
  fi
else
  echo "\`$*\` is not an symbolic link or regular file."
  exit 1
fi

#TODO: terminate options to echo or switch to printf
#TODO: terminate options to readlink
#TODO: check for broken symbolic links. Or maybe they should just be transformed normally?
#TODO: check permissions.
#TODO: preserve permissions?
#TODO: preserve modification time?
#TODO: check for race conditions?
