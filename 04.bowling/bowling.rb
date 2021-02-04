#!/usr/bin/env ruby

score = ARGV[0]
scores = score.chars
frame = []
frames = []

scores.each do |s|
  if s == 'X'
    frame << 10
  else
    frame << s.to_i
  end

  if frame[0] == 10 || frame.count == 2 || frames.count >= 10
    frames << frame
    frame = []
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
    if frame[0] == 10 && frames[i + 1][0] == 10
      point += frame[0] + frames[i + 1][0] + frames[i + 2][0]
    elsif frame[0] == 10 && frames[i + 1][0] != 10
      point += frame[0] + frames[i + 1][0] + frames[i + 1][1]
    elsif frame[0] != 10 && frame.sum == 10
      point += frame.sum + frames[i + 1][0]
    else
      point += frame.sum
    end
  when 8
    if frame[0] == 10
      point += frame[0] + frames[i + 1][0] + frames[i + 1][1]
    elsif frame.sum == 10
      point += frame.sum + frames[i + 1][0]
    else
      point += frame.sum
    end
  when 9
    point += frame.sum
  end
end

puts point
