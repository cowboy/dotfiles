#!/usr/bin/env python

# xkcd_password.py
# Simple python script to generate an xkcd password
# Recommended in http://xkcd.com/936/

import random
import re
import sys
import urllib2

def numberizeVowels(word):
    changed = ''
    for letter in word:
        if letter == 'a':
            changed += '4'
        elif letter == 'e':
            changed += '3'
        elif letter == 'i':
            changed += '1'
        elif letter == 'o':
            changed += '0'
        elif letter == 'u':
            changed += '2'
        else:
            changed += letter
    return changed

def generate(word_count = 4, joiner = '-', password_length = None):
    dictionaryURL = 'http://scrapmaker.com/data/wordlists/twelve-dicts/2of12.txt';
    randwords = []
    data = urllib2.urlopen(dictionaryURL)
    lines = data.read().split()
    generated = ''
    first = True
    for i in xrange(word_count):
        word = lines[random.randint(0, len(lines) - 1)].strip()

        # If the word is not all lowercase letters, get a new one
        while(re.match('^[a-z]+$', word) == None):
            word = lines[random.randint(0, len(lines) - 1)].strip()

        # Numberize first word
        if first:
            word = numberizeVowels(word)
            first = False

        # append to password
        randwords.append(word)
        generated += word.capitalize()

    if password_length != None and len(generated) > password_length:
        generated = generated[:password_length]

    return generated

if __name__ == '__main__':
    if len(sys.argv) == 2:
        print generate(password_length=int(sys.argv[1]))
    else:
        print generate()
