#!/usr/bin/env python

# marker_string.py
# A script to print a marker string, a string of a specified length with 
# markers in it to indicate how long the string is

import string
import sys

def marker_string(length):
    output = ''
    printed = 0
    for i in xrange(10, length, 10):
        if length - i > len(str(length)):
            output += string.rjust(str(i), 10, '_')
            printed += 10
    output += string.rjust(str(length), length - printed, '_')
    return output

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print 'Usage:', sys.argv[0], '<length>'
    else:
        for i in sys.argv[1:]:
            try:
                print marker_string(int(i))
            except ValueError:
                print i, 'is not an integer'
