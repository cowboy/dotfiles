#!/usr/bin/env python

# line_compare.py
# A script progressively print hashes of a file to ensure copied integrity

import hashlib
import sys
import re

def line_compare(filename):
    # Read the file
    with open(filename, 'r') as schema:
        lines = schema.readlines()

    md5 = hashlib.md5()
    for line in lines:
        md5.update(line)
        print md5.hexdigest()[:2], line.rstrip()
    print md5.hexdigest()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print 'Usage: ' + sys.argv[0] + ' [filename]'
        print '  To print a file hash line by line'
    else:
        line_compare(sys.argv[1])
