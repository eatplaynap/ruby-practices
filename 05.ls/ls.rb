#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

opt = ARGV.getopts('a', 'r', 'l')

files = if opt['a']
          Dir.glob(['*', '.*']).sort
        elsif opt['r']
          Dir.glob('*').sort.reverse
        else
          Dir.glob('*').sort
        end

if opt['l']
  def file_info(file)
    File::Stat.new(file)
  end

  def block_size(file)
    file_info(file).blocks
  end

  def file_type(file)
    key = file_info(file).ftype
    file_types = {
      'directory' => 'd',
      'file' => '-',
      'link' => 'l'
    }
    file_types[key]
  end

  def permission(file)
    permission_number = file_info(file).mode.to_s(8)[-3, 3]
    last_three_digits = permission_number.chars.map(&:to_i)
    permissions_trio = last_three_digits.map do |digit|
      letters = {
        0 => '---',
        1 => '--x',
        2 => '-w-',
        3 => '-wx',
        4 => 'r--',
        5 => 'r-x',
        6 => 'rw-',
        7 => 'rwx'
      }
      letters[digit]
    end
    permissions_trio.join('')
  end

  def number_of_links(file)
    file_info(file).nlink.to_s
  end

  def owner(file)
    Etc.getpwuid(file_info(file).uid).name
  end

  def group(file)
    Etc.getgrgid(file_info(file).gid).name
  end

  def byte_size(file)
    file_info(file).size.to_s
  end

  def time(file)
    file_info(file).mtime
  end

  def hour_and_minute_or_year(file)
    if time(file) < Date.today.prev_month(6).to_time || time(file) > Date.today.next_month(6).to_time
      time(file).year.to_s
    else
      time(file).strftime('%H:%M').to_s
    end
  end

  def month(file)
    time(file).month.to_s
  end

  def day(file)
    time(file).day.to_s
  end

  def name(file)
    File.basename(file)
  end

  block = 0
  opt_l_outputs = []
  files.each do |s|
    block += block_size(s)
    permission_letters = file_type(s) + permission(s)
    opt_l_outputs << [
      permission_letters,
      number_of_links(s).rjust(2),
      "#{owner(s)} ",
      "#{group(s)} ",
      byte_size(s).rjust(4),
      month(s).rjust(2),
      day(s).rjust(2),
      hour_and_minute_or_year(s).rjust(5),
      name(s)
    ]
  end

  puts "total #{block}"

  opt_l_outputs.each do |output|
    puts output.join(' ')
  end

else
  longest_file_name = files.max_by(&:size).size.to_i
  width = 8 * (longest_file_name / 8.to_f).ceil

  temporary_array = []
  files.each do |file|
    space = width - file.size
    file += ' ' * space
    temporary_array << file
  end

  number_of_lines = 3
  divisor_enables_three_chunks = Rational(files.size, number_of_lines).ceil
  three_chunked_arrays = temporary_array.each_slice(divisor_enables_three_chunks).to_a

  biggest_element = three_chunked_arrays.map(&:length).max
  three_chunked_arrays.map { |e| e.values_at(0...biggest_element) }.transpose.each do |array|
    puts array.join(' ')
  end
end
