#!/usr/bin/env node

//
// renamer.js
// A script to perform various renaming operations on files in a directory
//

var fs = require('fs'),
  path = require('path');

try {
  var minimist = require('minimist');
} catch (err) {
  console.error('Failed to load minimist module.');
  console.error('  Run \'npm install\' in the ~/bin directory.');
  process.exit(1);
}

function rename(filename, options) {
  var ext = path.extname(filename);
  var base = path.basename(filename, ext);

  if (options.hasOwnProperty('l') || options.hasOwnProperty('lowercase')) {
    ext = ext.toLowerCase();
    base = base.toLowerCase();
  }

  if (options.hasOwnProperty('p') && typeof options.p == 'string') {
    base = options.p + base;
  }

  if (options.hasOwnProperty('prefix') && typeof options.prefix == 'string') {
    base = options.prefix + base;
  }

  if (options.hasOwnProperty('t') || options.hasOwnProperty('prefix-today')) {
    var today = new Date();
    base = today.toJSON().substr(0, 10) + '_' + base;
  }

  if (options.hasOwnProperty('u') || options.hasOwnProperty('underscore')) {
    base = base.replace(/ /g, '_');
  }

  var newname = path.join(path.dirname(filename), base + ext);
  fs.renameSync(filename, newname);
  console.log(filename + ' -> ' + newname);
}

function analyzeList(args) {
  var files = [];
  for (var i = 0; i < args._.length; i++) {
    var item = args._[i];
    var stats = fs.statSync(item);
    if (stats.isDirectory()) {
      var local = fs.readdirSync(item);
      for (var j = 0; j < local.length; j++) {
        var filename = path.join(item, local[j]);
        files.push(filename)
      }
    } else {
      files.push(item);
    }
  }

  for (var i = 0; i < files.length; i++) {
    rename(files[i], args);
  }
}

function usage() {
  console.log('Usage: ' + process.argv[1] + ' -[lptu] -- {files or directories}');
  console.log('  -l or --lowercase - change captials to lowercase');
  console.log('  -p or --prefix {prefix} - prefix with arbitrary information');
  console.log('  -t or --prefix-today - prefix with today\'s YYYY-MM-DD date');
  console.log('  -u or --underscore - change spaces to underscores');
}

// "main" function
if (require.main === module) {
  if (process.argv.length > 2) {
    analyzeList(minimist(process.argv.slice(2)));
  } else {
    usage();
  }
}

