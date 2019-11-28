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

        try
            do shell script "hackscode remove-build-files --from-target AbemaTVTests --matching UI.*Spec.swift --excluding " & sourceName1 & " --project-root " & projectFolder
            display notification "👌 Ignored all specs except " & sourceName1 with title "Hackscode"
        on error errStr number errorNumber
            display notification "🛑 " & errStr & " (" & errorNumber & ")"
        end try
    end tell
end run
```

Set the script trigger to Xcode Behavior.

![Xcode Behavior](https://camo.qiitausercontent.com/02b1e04f2d663055e427dcfad0aa754b065bf058/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e616d617a6f6e6177732e636f6d2f302f33353030382f62343838383034662d636133392d656132662d303132612d6433656262326330306636622e706e67)

# Install
Mint
```
mint install toshi0383/hackscode
```

# Development
Run following to start development.
```
make bootstrap
```

You will need to run this after you changed command interface.
```
make sourcery
```
See: https://github.com/toshi0383/CoreCLI

# LICENSE
MIT
