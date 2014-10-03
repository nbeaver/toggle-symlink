# Prevent make from looking for a file called 'all'
.PHONY : all
all:
	./test.sh

# Prevent make from looking for a file called 'clean'
.PHONY: clean
clean:
	rm --recursive --force -- example-symlinks/
