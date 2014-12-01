#!/usr/bin/env ruby

unless(ARGV[0])
  puts "You should provide the HTML file path"
  exit
end

require 'rubygems'
require 'hpricot'
html = File.read(ARGV[0])
class Hpricot::Text
  def to_slim(lvl=0)
    if to_s.strip.empty?
      nil
    else
      ('  ' * lvl) + %(| #{to_s.gsub(/\s+/, ' ')})
    end
  end
end
class Hpricot::Comment
  def to_slim(lvl=0)
    # For SHTML <!--#include virtual="foo.html" -->
    if self.content =~ /include (file|virtual)="(.+)"/
      ('  ' * lvl) + "= render '#{$~[2]}'"
    else
      nil
    end
  end
end
class Hpricot::DocType
  def to_slim(lvl=0)
    'doctype'
  end
end
class Hpricot::Elem
  def slim(lvl=0)
    r = ('  ' * lvl)
    if self.name == 'div' and (self.has_attribute?('id') || self.has_attribute?('class'))
      r += ''
    else
      r += self.name
    end
    if(self.has_attribute?('id'))
      r += "##{self['id']}"
      self.remove_attribute('id')
    end
    if(self.has_attribute?('class'))
      r += ".#{self['class'].split(/\s+/).join('.')}"
      self.remove_attribute('class')
    end
    unless attributes_as_html.to_s.strip.empty?
      r += "[#{attributes_as_html.to_s.strip}]"
    end
    r
  end
  def to_slim(lvl=0)
    if respond_to?(:children) and children
      return %(#{self.slim(lvl)}\n#{children.map { |x| x.to_slim(lvl+1) }.select{|e| !e.nil? }.join("\n")})
    else
      self.slim(lvl)
    end
  end

end
class Hpricot::Doc
  def to_slim
    if respond_to?(:children) and children
      children.map { |x| x.to_slim }.select{|e| !e.nil? }.join("\n")
    else
      ''
    end
  end
end
if ARGV[1]
  File.open(ARGV[1],'w'){|f| f.write Hpricot(html).to_slim }
else
  puts Hpricot(html).to_slim
end