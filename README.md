# hackscode

A hacky partner for my life with Xcode. Maybe for you too?

# Actions
## remove-build-files

> Swift compile time is so expensive. Let's ignore all files but one which I'm working on right now.💡

Install and call it from AppleScript so it's also callable from Xcode.

```
#!/usr/bin/osascript

use AppleScript version "2.4" # Yosemite or later
use scripting additions
use framework "Foundation"

on run
    tell application "Xcode"
        set projectPath to path of active workspace document
        set projectFolder to characters 1 thru -((offset of "/" in (reverse of items of projectPath as string)) + 1) of projectPath as string
        set sourceName1 to (get name of window 1)

        do shell script "hackscode remove-build-files --from-target Tests --matching Spec.swift --excluding " & sourceName1
        display dialog "👌Deleted All Specs from PBXBuildFile Section Except for " & sourceName1 & "🚮"
    end tell
end run
```

# Install
```
mint install toshi0383/hackscode
```

# LICENSE
MIT
