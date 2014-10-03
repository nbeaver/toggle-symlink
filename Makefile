all:
	mkdir -p example-symlinks
	cd example-symlinks/
	echo "hello" > file.txt
	ln --symbolic file.txt 'link to file.txt'
	ln --symbolic file.txt '*'
	ln --symbolic file.txt '--force *'
	./toggle-symlink.sh 'example-symlinks/link to file.txt'
	./toggle-symlink.sh 'example-symlinks/link to file.txt'
	./toggle-symlink.sh 'example-symlinks/*'
	./toggle-symlink.sh 'example-symlinks/*'
	./toggle-symlink.sh 'example-symlinks/--force *'
	./toggle-symlink.sh 'example-symlinks/--force *'
# Prevent make from looking for a file called 'all'
.PHONY : all

