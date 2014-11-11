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
  var dir = path.dirname(__filename);
  console.error('  Run \'npm install\' in the ' + dir + ' directory.');
  process.exit(1);
}

function rename(filename, options) {
  // Separate path
  var ext = path.extname(filename);
  var base = path.basename(filename, ext);

  // Lowercase
  if (options.hasOwnProperty('l') || options.hasOwnProperty('lowercase')) {
    ext = ext.toLowerCase();
    base = base.toLowerCase();
  }

  // Chop
  if (options.hasOwnProperty('c') && typeof options.c == 'number') {
    base = base.substring(options.c);
  }
  if (options.hasOwnProperty('chop') && typeof options.chop == 'number') {
    base = base.substring(options.chop);
  }

  // Prefix
  if (options.hasOwnProperty('p') && typeof options.p == 'string') {
    base = options.p + base;
  }
  if (options.hasOwnProperty('prefix') && typeof options.prefix == 'string') {
    base = options.prefix + base;
  }

  // Today's date
  if (options.hasOwnProperty('t') || options.hasOwnProperty('prefix-today')) {
    var today = new Date();
    base = today.toJSON().substr(0, 10) + '_' + base;
  }

  // Underscore
  if (options.hasOwnProperty('u') || options.hasOwnProperty('underscore')) {
    base = base.replace(/ /g, '_');
  }

  // Combine new name
  var newname = path.join(path.dirname(filename), base + ext);
  // If not dry-running, do the rename
  if (!options.hasOwnProperty('d') && !options.hasOwnProperty('dry-run')) {
    fs.renameSync(filename, newname);
  }
  // Print change
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
  console.log('Usage: ' + process.argv[1] + ' -[cdlptu] -- {files or directories}');
  console.log('  -c or --chop {number} - chop characters off the front');
  console.log('  -d or --dry-run - dry run, don\'t actually rename files');
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

