#!/usr/bin/env python

# resizer.py
# a script to resize a whole directory of images

import glob
import os
import re
import shutil
import subprocess
import sys

def getDimensions(filename):
    output = subprocess.check_output(['sips',
                                      '-g', 'pixelWidth',
                                      '-g', 'pixelHeight',
                                      filename])

    width = re.search('pixelWidth: (\\d+)', output).groups()[0]
    height = re.search('pixelHeight: (\\d+)', output).groups()[0]

    return (int(width), int(height))
    
def resize(name, new_name, max_dimension):
    # get dimensions
    width, height = getDimensions(name)

    # calculte new height and width 
    new_height = new_width = 0
    if width > height:
        if width > max_dimension:
            new_width = max_dimension
            new_height = height * max_dimension / width
    else:
        if height > max_dimension:
            new_height = max_dimension
            new_width = width * max_dimension / height 

    # if there are new dimensions, scale image
    if new_height > 0:
        # print new_height, new_width, float(new_height) / new_width
        subprocess.call(['sips',
                         '-z', str(new_height), str(new_width),
                        name,
                         '--out', new_name])

    # otherwise just copy it
    else:
        shutil.copyfile(name, new_name)
    
if __name__ == '__main__':
    if len(sys.argv) == 4:
        input_dir = sys.argv[1]
        output_dir = sys.argv[2]
        if not os.path.exists(output_dir):
            os.mkdir(output_dir)
        max_dimension = int(sys.argv[3])
        for filename in  glob.glob(os.path.join(input_dir, '*')):
            new_filename = os.path.join(output_dir, os.path.basename(filename))
            resize(filename, new_filename, max_dimension)
    else:
        print 'Usage:', sys.argv[0], '<input_dir> <output_dir> <max_dimension>'
