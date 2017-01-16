#!/usr/bin/env node

const fs = require('fs');
const getStdin = require('get-stdin');

function pprint(filename) {
  // Read
  try {
    var data = fs.readFileSync(filename).toString();
  } catch (e) {
    console.log('Error reading from file: ' + filename);
    return;
  }

  // Parse
  try {
    var json = JSON.parse(data);
  } catch (e) {
    console.log('Error parsing json from file: ' + filename);
    console.log(e);
    return;
  }

  // Print
  console.log(JSON.stringify(json, undefined, 2));
}

// "main" function
if (require.main === module) {
  if (process.argv.length == 2) {
    getStdin().then(input => console.log(JSON.stringify(JSON.parse(input), undefined, 2)));
  } else if (process.argv.length == 3) {
    pprint(process.argv[2]);
  } else if (process.argv.length > 3) {
    for (var i = 2; i < process.argv.length; i++) {
      console.log(process.argv[i]);
      pprint(process.argv[i]);
    }
  } else {
    console.log('Usage: ' + process.argv[1] + ' <json files>');
    console.log('  with no files, pretty prints from stdin');
    console.log('  with one file, just pretty prints it');
    console.log('  with multiple files, prints filenames before output');
  }
}

