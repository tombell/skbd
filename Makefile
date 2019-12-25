RELEASE_BUILD=./.build/release
EXECUTABLE=skbd
PREFIX?=/usr/local/bin
ARCHIVE=$(EXECUTABLE).tar.gz

SRC=$(wildcard Sources/skbd/*.swift)

SWIFTC_FLAGS=-Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.15"

all: build

lint:
	swiftlint lint

format:
	swiftformat Sources/**/* Tests/**/*

test:
	swift test $(SWIFTC_FLAGS)

clean:
	rm -f $(EXECUTABLE) $(ARCHIVE)
	swift package clean

build: $(SRC)
	swift build $(SWIFTC_FLAGS)

release: clean
	swift build --configuration release $(SWIFTC_FLAGS)

package: release
	tar -pvczf $(ARCHIVE) -C $(RELEASE_BUILD) $(EXECUTABLE)
	tar -zxvf $(ARCHIVE)
	@shasum -a 256 $(ARCHIVE)
	@shasum -a 256 $(EXECUTABLE)
	rm $(EXECUTABLE)

.PHONY: all lint format test clean build release package
