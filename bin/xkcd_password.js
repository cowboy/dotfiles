#!/usr/bin/env node

// Simple Node.js script to generate an xkcd password
// Based on recommendation in http://xkcd.com/936/

var crypto = require('crypto');
var fs = require('fs');
var path = require('path');

// Configuration
var dir = path.dirname(__filename);
var dictionaryFile = path.join(dir, '../conf/2of12.txt');
var phraseCount = 4;

function numberizeVowels(word) {
  var changed = '';
  var map = {
    a: 4,
    e: 3,
    i: 1,
    o: 0,
    u: 2
  }
  for (var i = 0; i < word.length; i++) {
    var letter = word[i];
    if (map.hasOwnProperty(word[i])) {
      changed += map[word[i]];
    } else {
      changed += letter;
    }
  }
  return changed;
}

// Returns a secure random int in the range [min, max)
function randInt(min, max) {
  var buf = crypto.randomBytes(32);
  var rand = Math.abs(buf.readInt32BE(0));
  var spread = max - min;
  return rand % spread + min;
}

function generate(length) {
  var data = fs.readFileSync(dictionaryFile).toString();
  var lines = data.split('\n');
  generated = '';
  first = true;

  for (var i = 0; i < phraseCount; i++) {
    var word = lines[randInt(0, lines.length)].trim();

    // If the word is not all lowercase letters, get a new one
    while (word.match(/^[a-z]+$/) === null) {
      word = lines[randInt(0, lines.length)].trim();
    }

    // Capitalize
    word = word.charAt(0).toUpperCase() + word.slice(1);

    // Numberize first word
    if (first) {
      word = numberizeVowels(word);
      first = false;
    }

    // Append to password
    generated += word;
  }

  if (typeof length != 'undefined' && generated.length > length) {
    generated = generated.substring(0, length);
  }

  return generated;
}

if (require.main === module) {
  if (process.argv.length > 2) {
    console.log(generate(parseInt(process.argv[2])));
  } else {
    console.log(generate());
  }
}
