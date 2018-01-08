#!/usr/bin/env bash

# Enable POSIX compatibility mode for portability.
set -o posix

# Treat unset variables and parameters
# other than the special parameters "@" and "*"
# as an error when performing parameter expansion.
set -o nounset

symlink_to_txt () {
    local SOURCE="$*"
    local TARGET="$(readlink -- "$SOURCE")"
    local TMP="$(mktemp)"
    printf '%s' "$TARGET" > "$TMP"
    if mv -T -- "$TMP" "$SOURCE"
    then
        return 0
    else
        printf 'Error: could not convert symlink to text: %s\n' "$SOURCE"
        return 1
    fi
}

txt_to_symlink() {
    local SOURCE="$*"
    # Store file contents in the $TARGET variable.
    local TARGET="$(<"$SOURCE")"
    local TMP="$(mktemp)"
    mv -- "$SOURCE" "$TMP"
    if ln --symbolic -- "$TARGET" "$SOURCE"
    then
        rm -- "$TMP"
        return 0
    else
        mv -- "$TMP" "$SOURCE"
        printf 'Error: could not convert to symlink: %s\n' "$SOURCE"
        return 1
    fi
}

toggle_symlink() {
    if test -L "$*"
    then
        # If the input file exists and is a symbolic link (-L),
        # we want to turn it into a text file with the same name.
        symlink_to_txt "$*"
        return 0
    elif test -f "$*"
    then
        # However, if the input is a regular file (-f) with a non-zero size (-s),
        # we want to turn it into a symbolic link to wherever its contents point.
        txt_to_symlink "$*"
        return 0
    else
        printf 'Error: not a symbolic link or regular file: %s\n' "$*"
        return 1
    fi
}

# Show usage information if there are no arguments.
if test $# -eq 0
then
    printf 'Usage: %s /path/to/file\n' "$0"
    exit 1;
fi

for file in "$@"
do
    toggle_symlink "$file"
done
