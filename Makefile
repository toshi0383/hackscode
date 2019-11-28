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
	rm -rf Pods Podfile.lock *.xcodeproj # Cleaning up to avoid cocoapods failing to bootstrap from Podfile.lock
	swift package generate-xcodeproj # Creating one for CocoaPods to work.
	pod install # Installing sourcery for swifttemplate support.
	swift package generate-xcodeproj # Discarding cocoapods side effects, gracefully.

sourcery:
	./scripts/run-sourcery
