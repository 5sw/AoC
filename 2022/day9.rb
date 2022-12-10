require "set"

def moveStep(dx, dy)
  $headX += dx
  $headY += dy
  
  (curX, curY) = [$headX, $headY]
  
  $tail.each_index { |index|
    (tailX, tailY) = $tail[index]

    dx = curX - tailX
    dy = curY - tailY
    
    case [dx.abs, dy.abs]
    when [0, 0], [1, 1], [1, 0], [0, 1] then
      # Stay the same
    when [2, 0], [0, 2], [2, 2] then
      tailX += dx <=> 0
      tailY += dy <=> 0
    when [2, 1] then
      tailX += dx <=> 0
      tailY += dy <=> 0
    when [1, 2] then
      tailX += dx <=> 0
      tailY += dy <=> 0
    else 
      puts "Unknown: (#{dx}, #{dy})"
      raise 
    end
    
    (curX, curY) = $tail[index] = [tailX, tailY]
  }

  $tailPositions.add [curX, curY]
end


def run count
  $headX = 0
  $headY = 0

  $tail = [[$headX, $headY]] * (count - 1)
  
  $tailPositions = Set[[$headX, $headY]]

  for line in File.readlines('day9.input') 
    unless /^(?<dir>[RLUD]) (?<steps>\d+)$/ =~ line
      puts "Failed to parse #{line}"
      raise
    end
    
    steps = steps.to_i
    
    case dir
    when "R" then
      steps.times { moveStep 1, 0 }
    when "L" then
      steps.times { moveStep -1, 0 }
    when "U" then
      steps.times { moveStep 0, 1 }
    when "D" then
      steps.times { moveStep 0, -1 }
    end
  end
  
  $tailPositions.count
end

puts "Part 1: #{run(2)}"
puts "Part 2: #{run(10)}"

