VERSION=0.4.3
FILES = \
	install.rdf \
	bootstrap.js \
	WINNT \
	Darwin \
	$(NULL)

all: package

package: webvr-oculus-addon-$(VERSION).xpi

webvr-oculus-addon-$(VERSION).xpi: $(FILES)
	rm -f $@
	zip -9r $@ $^
