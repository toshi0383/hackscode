.PHONY = clean update build bootstrap
SOURCERY ?= sourcery # Please install appropriate version on your own.
cmdshelf ?= cmdshelf

clean:
	rm -rf .build
	rm Package.resolved

update:
	swift package update

build:
	swift build

bootstrap:
	pod install # Installing sourcery for swifttemplate support.
	swift package generate-xcodeproj # Discarding cocoapods side effects, gracefully.

# Needs toshi0383/scripts to be added to cmdshelf's remote
install:
	$(cmdshelf) run swiftpm/install.sh toshi0383/hackscode

release:
	rm -rf .build/release
	swift build -c release -Xswiftc -static-stdlib
	$(cmdshelf) run swiftpm/release.sh hackscode

sourcery:
	./scripts/run-sourcery
