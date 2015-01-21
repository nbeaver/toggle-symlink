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
		echo "Warning: did not convert \`$file\` because \`$TARGET\` is not a valid target for a symbolic link."
		return 2
	fi
}

toggle_symlink() {
	# If the input file exists and is a symbolic link (-L),
	# we want to turn it into a text file with the same name.
	if [ -L "$*" ]; then
		symlink_to_txt "$*"
		# However, if the input is a regular file (-f) with a non-zero size (-s),
		# we want to turn it into a symbolic link to wherever its contents point.
	elif [ -f "$*" -a -s "$*" ]; then
		txt_to_symlink "$*"
	else
		echo "Warning: did not convert \`$file\` because is not a symbolic link or regular file."
		return 1
	fi
}

# Show usage information if there are no arguments.
if [ $# == 0 ] ; then
	echo "Usage: toggle-symlink.sh command-name"
	exit 1;
fi

for file in "$@"
do
	toggle_symlink "$file"
done
