#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.chars
shots = []
frames = []

scores.each do |s|
  shots << if s == 'X'
             10
           else
             s.to_i
           end

  if shots[0] == 10 || shots.count == 2 || frames.count >= 10
    frames << shots
    shots = []
  elsif frames.count == 12
    frames[10].concat(frames[11])
  end

  next unless frames.count > 10

  if frames[9].sum >= 10
    frames[9].concat(frames[10])
    frames.pop(1)
  end
end

point = 0
frames.each_with_index do |frame, i|
  case i
  when 0..7
    point += if frame[0] == 10 && frames[i + 1][0] == 10
               frame[0] + frames[i + 1][0] + frames[i + 2][0]
             elsif frame[0] == 10 && frames[i + 1][0] != 10
               frame[0] + frames[i + 1][0] + frames[i + 1][1]
             elsif frame[0] != 10 && frame.sum == 10
               frame.sum + frames[i + 1][0]
             else
               frame.sum
             end
  when 8
    point += if frame[0] == 10
               frame[0] + frames[i + 1][0] + frames[i + 1][1]
             elsif frame.sum == 10
               frame.sum + frames[i + 1][0]
             else
               frame.sum
             end
  when 9
    point += frame.sum
  end
end

puts point
