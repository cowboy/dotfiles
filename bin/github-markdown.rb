#!/usr/bin/env ruby

require 'github/markdown'

# Oneliner from http://stackoverflow.com/questions/7694887
puts GitHub::Markdown.render_gfm File.read(ARGV[0])
