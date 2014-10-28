#!/usr/bin/env python

# clean_schema.py
# A script to clean a mysqldump'd schema file

import sys
import re

def clean_schema(filename, cleanname):
    # Read the file
    with open(filename, 'r') as schema:
        lines = schema.readlines()

    # Sort the keys and constraints
    # This step is necessary because mysqldump doesn't guarantee the order
    # that keys and constraints come out in.  When trying to compare,
    # having the order change is a problem.
    output = '' # output sql
    mode = 'normal' # mode is normal unless dealing with a key/constraint line
    keys = []       # array of keys
    constraints = [] # array of constraints
    for line in lines:
        if mode == 'normal':
            # From normal mode, check for entry into special mode, save
            # the line rather than appending it to output
            # Stripping the commas and \n's off the end allows them to be
            # put in later
            if line.strip().startswith('KEY'):
                keys.append(line.rstrip(',\n'))
                mode = 'special'
            elif line.strip().startswith('CONSTRAINT'):
                constraints.append(line.rstrip(',\n'))
                mode = 'special'
            else:
                output += line
        else: # mode == 'special':
            # From special mode, collect keys and constraints
            # A line starting with ) means the end of the table definition
            # Sort the keys and constraints separately, then concatenate the
            # arrays. Put in new commas between the lines.
            # The line with the ) may have an auto-increment flag in it,
            # which should also be removed for comparison
            if line.strip().startswith('KEY'):
                keys.append(line.rstrip(',\n'))
            elif line.strip().startswith('CONSTRAINT'):
                constraints.append(line.rstrip(',\n'))
            elif line.strip().startswith(')'):
                keys.sort()
                constraints.sort()
                keys.extend(constraints)
                output += ',\n'.join(keys) + '\n'
                output += re.sub(' AUTO_INCREMENT=\\d+', '', line)
                keys = []
                constraints = []
                mode = 'normal'

    # write cleaned output to a file
    with open(cleanname, 'w') as schema:
        schema.write(output)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print 'Usage: ' + sys.argv[0] + ' [original dump] [cleaned sql]'
        print '  To clean/organize mysqldump output for comparison'
    else:
        clean_schema(sys.argv[1], sys.argv[2])
