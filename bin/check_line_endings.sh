#!/bin/bash

# check_line_endings.sh
# Checks the ending of the first line in each filename passed for dos or unix

for file in $@; do
    if [ -f $file ]
        then
            [[ $(head -1 $file) == *$'\r' ]] \
                && echo "[dos]" $file \
                || echo "[nix]" $file
    fi
done

