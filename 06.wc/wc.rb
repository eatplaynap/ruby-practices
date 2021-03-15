#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLUMN_WIDTH = 8

def main
  @opt = ARGV.getopts('l')
  files = ARGV
  if files.empty?
    puts output_for_zero_files
  elsif files.size == 1
    puts output_for_files(files)
  else
    puts output_for_files(files)
    puts total_count(files)
  end
end

def output_for_zero_files
  text = $stdin.read
  if @opt['l']
    ingredients_for_output(text).first
  else
    ingredients_for_output(text).join
  end
end

def output_for_files(files)
  files.map do |file|
    text = File.read(file)
    if @opt['l']
      ingredients_for_output(text, file).first
    else
      ingredients_for_output(text, file).join
    end
  end
end

def ingredients_for_output(text, file = nil)
  lines = text.lines.count
  words = text.split(/\s+/).size
  bytes = text.size
  name = File.basename(file) if file
  [lines.to_s.rjust(COLUMN_WIDTH), words.to_s.rjust(COLUMN_WIDTH), bytes.to_s.rjust(COLUMN_WIDTH), " #{name}"]
end

def total(files)
  files.map do |file|
    text = File.read(file)
    lines = text.lines.count
    words = text.split(/\s+/).size
    bytes = text.size
    if @opt['l']
      [lines]
    else
      [lines, words, bytes]
    end
  end
end

def total_count(files)
  total_count = total(files).transpose.map(&:sum)
  total_with_space = total_count.map do |number|
    number.to_s.rjust(COLUMN_WIDTH)
  end
  "#{total_with_space.join} total"
end

main
