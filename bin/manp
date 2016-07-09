#!/usr/bin/env bash

if [[ "$1" == "-h" || "$1" == "--help" ]]; then cat <<HELP
Manpage-as-PDF Viewer
http://benalman.com/

Usage: $(basename "$0") [section] name

View a manpage as PDF in the default viewer (Preview.app). Because sometimes
you don't want to view manpages in the terminal.

Copyright (c) 2012 "Cowboy" Ben Alman
Licensed under the MIT license.
http://benalman.com/about/license/
HELP
exit; fi

if [ ! "$1" ]; then
  echo 'What manual page do you want?!'
  exit
fi

cache_dir=$DOTFILES/caches/manpdf

# Figure out what the filename should be.
file="$cache_dir/${2:+$2.}$1.pdf"

# Create directory if it doesn't exist.
[[ -e "$cache_dir" ]] || mkdir -p "$cache_dir"

# Create PDF if it doesn't exist.
[[ -e "$file" ]] || man -t "$@" | pstopdf -i -o "$file" >/dev/null 2>&1

# Open PDF (if it does exist).
[[ -e "$file" ]] && open "$file"
