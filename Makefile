# Prevent make from looking for a file called 'all'
.PHONY : all
all:
	./test.sh
	rst2html README.rst README.html

# Prevent make from looking for a file called 'clean'
.PHONY: clean
clean:
	rm --recursive --force -- example-symlinks/
	rm --force README.html
