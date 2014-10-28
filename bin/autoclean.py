#!/usr/bin/python

#
# autoclean.py
# script to autoclean text files
#

import os
import sys
from string import replace
from re import sub

def autoclean(filename):
    clean = ''

    # read and process file
    with open(filename) as f:
        for line in f.readlines():
            # convert tabs to four spaces
            line = replace(line, '\t', '    ')

            # remove trailing whitespace
            line = sub(r'\s+$', '', line)

            # make sure there is a space before branch
            line = replace(line, 'foreach(', 'foreach (')
            line = replace(line, 'for(', 'for (')
            line = replace(line, 'if(', 'if (')
            line = replace(line, 'while(', 'while (')
            line = replace(line, 'else{', 'else {')
            line = replace(line, '}else', '} else')
            line = replace(line, '){', ') {')

            # put spaces around php assignments
            line = sub(r'(^\s+\$\w+)\s*=\s*(\S)', r'\1 = \2', line)

            # append line to clean file buffer
            clean += line + os.linesep

    # write file back out
    with open(filename, 'wb') as f:
        f.write(clean)

    print 'autocleaned', filename

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print 'Usage:', sys.argv[0], '{filename}'
        sys.exit(1)
    for i in xrange(1, len(sys.argv)):
        autoclean(sys.argv[i])
    print 'done.'
