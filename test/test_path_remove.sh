#!/usr/bin/env bash
source $DOTFILES/source/00_dotfiles.sh

e_header "$(basename "$0" .sh)"

PATH=/a/b:/a/b/c:/a/b:/a/b/d
assert "$PATH" path_remove /a
assert "$PATH" path_remove /a/b/c/d
assert "/a/b/c:/a/b/d" path_remove /a/b
assert "/a/b:/a/b:/a/b/d" path_remove /a/b/c
assert "/a/b:/a/b/c:/a/b" path_remove /a/b/d

PATH="/a/b:/a/b c/d:/a/b:/a/b c/e"
assert "$PATH" path_remove /a
assert "$PATH" path_remove /a/b/c/d
assert "/a/b c/d:/a/b c/e" path_remove /a/b
assert "/a/b:/a/b:/a/b c/e" path_remove "/a/b c/d"
assert "/a/b:/a/b c/d:/a/b" path_remove "/a/b c/e"

PATH=/a/b:/a/b/c:/x:/a/b/d:/y:/a/b/e:/z
assert "/a/b:/x:/y:/z" path_remove /a/b/c /a/b/d /a/b/e
