SH :=$(wildcard *.sh)
RST :=$(wildcard *.rst)
HTML :=$(patsubst %.rst, %.html, $(RST))

.PHONY : all clean shellcheck

all: $(HTML)
	./test.sh

%.html : %.rst
	rst2html $< $@

shellcheck:
	shellcheck $(SH)

clean:
	rm -f -- $(HTML)
