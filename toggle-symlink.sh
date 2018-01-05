#!/usr/bin/env bash

# Enable POSIX compatibility mode for portability.
set -o posix

# Treat unset variables and parameters
# other than the special parameters "@" and "*"
# as an error when performing parameter expansion.
set -o nounset

# Don't overwrite an existing file.
set -o noclobber

symlink_to_txt () {
    local TARGET="$(readlink -- "$*")"
    rm -- "$*"
    printf '%s' "$TARGET" > "$*"
}

txt_to_symlink() {
    # Store file contents in the $TARGET variable.
    local TARGET="$(<"$*")"
    # Check to see if the file contents are a valid path.
    if test -e "$TARGET"
    then
        rm -- "$*"
        ln --symbolic -- "$TARGET" "$*"
    else
        printf 'Error: did not convert `%s` because `%s` is not a valid target for a symbolic link.' "$file" "$target"
        return 2
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
        printf 'Error: did not convert `%s` because it is not a symbolic link or regular file.' "$*"
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
    if test -f "$file"
    then
        toggle_symlink "$file"
    else
        printf 'Warning: path does not exist: %s' "$file"
    fi
done
