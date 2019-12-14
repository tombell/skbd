RELEASE_BUILD=./.build/release
EXECUTABLE=skbd
PREFIX?=/usr/local/bin
ARCHIVE=$(EXECUTABLE).tar.gz

SRC=$(wildcard Sources/skbd/*.swift)

all: build

test:
	swift test

clean:
	rm -f $(EXECUTABLE) $(ARCHIVE)
	swift package clean

build: $(SRC)
	swift build

release: clean
	swift build --configuration release

package: release
	tar -pvczf $(ARCHIVE) -C $(RELEASE_BUILD) $(EXECUTABLE)
	tar -zxvf $(ARCHIVE)
	@shasum -a 256 $(ARCHIVE)
	@shasum -a 256 $(EXECUTABLE)
	rm $(EXECUTABLE)

install: release
	install $(RELEASE_BUILD)/$(EXECUTABLE) $(PREFIX)

uninstall:
	rm "$(PREFIX)/$(EXECUTABLE)"

.PHONY: all test clean build release package install uninstall
