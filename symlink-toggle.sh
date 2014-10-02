#!/usr/bin/env bash
# Treat unset variables and parameters
# other than the special parameters "@" and "*"
# as an error when performing parameter expansion.
set -o nounset

# Terminate as soon as any command fails.
set -e

# If the input file exists and is a symbolic link,
# we want to turn it into a text file with the same name.
if [ -L $* ]
then
  TARGET=$(readlink --canonicalize-existing $*)
  rm -- $*
  echo "$TARGET" > $*
elif [ -f $* -a -s $* ]
then
  TARGET=$(<$*)
  rm -- $*
  ln --symbolic $TARGET "$*" 
else
  echo "`$*` is not an symbolic link or regular file."
fi

#TODO: check for broken symbolic links.
#TODO: check permissions.
#TODO: preserve permissions?
#TODO: preserve modification time?
#TODO: check for race conditions?
