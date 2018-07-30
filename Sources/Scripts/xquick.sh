#!/bin/bash
FILE=$(find . -name ${1:?} | head -1)
if [ $# -eq 2 ]; then
    # Revert
    COMMAND='s,  xdescribe\(.*\) // xquick,  describe\1,;s,  xcontext\(.*\) // xquick,  context\1,;s,  xit\(.*\) // xquick,  it\1,;s, // xquick,,'
else
    # Apply
    COMMAND='s,  describe\(.*\),  xdescribe\1 // xquick,;s,  context\(.*\),  xcontext\1 // xquick,;s,  it\(.*\),  xit\1 // xquick,'
fi
sed -i "" -e "$COMMAND" "$FILE"
