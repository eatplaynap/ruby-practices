#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  @opt = ARGV.getopts('l')
  files = ARGV
  if @opt['l'] && files.size == 1
    puts output_for_l(files)
  elsif @opt['l'] && files.size > 1
    puts output_for_l(files)
    puts total_count(files)
  elsif files.empty?
    puts output_for_zero_files(files)
  elsif files.size > 1
    puts output_for_files(files)
    puts total_count(files)
  else
    puts output_for_files(files)
  end
end

def output_for_zero_files(files)
  text = $stdin.read
  lines = text.lines.count
  words = text.split(/\s+/).size
  bytes = text.size
  [] << [
    lines.to_s.rjust(8),
    words.to_s.rjust(8),
    bytes.to_s.rjust(8)
  ].join('')
end

def output_for_files(files)
  files.map do |file|
    text = File.read(file)
    lines = text.lines.count
    words = text.split(/\s+/).size
    bytes = File.open(file).size
    name = File.basename(file)
    [] << [
      lines.to_s.rjust(8),
      words.to_s.rjust(8),
      bytes.to_s.rjust(8),
      " #{name}"
    ].join('')
  end
end

def total(files)
  files.map do |file|
    text = File.read(file)
    lines = text.lines.count
    words = text.split(/\s+/).size
    bytes = File.open(file).size
    if @opt['l']
      [] << lines
    else
      [] << lines << words << bytes
    end
  end
end

def total_count(files)
  total_count = total(files).transpose.map { |a| a.inject(:+) }
  total_with_space = total_count.map do |number|
    number.to_s.rjust(8)
  end
  "#{total_with_space.join('')} total"
end

def output_for_l(files)
  files.map do |file|
    text = File.read(file)
    lines = text.lines.count
    name = File.basename(file)
    [] << [
      lines.to_s.rjust(8),
      " #{name}"
    ].join('')
  end
end

main