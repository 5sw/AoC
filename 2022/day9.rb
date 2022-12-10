require "set"

def moveStep(dx, dy)
  $headX += dx
  $headY += dy
  
  dx = $headX - $tailX
  dy = $headY - $tailY
  
  case [dx.abs, dy.abs]
  when [0, 0], [1, 1], [1, 0], [0, 1] then
    
  when [2, 0], [0, 2], [2, 2] then
    $tailX += dx <=> 0
    $tailY += dy <=> 0
  when [2, 1] then
    $tailX += dx <=> 0
    $tailY += dy <=> 0
  when [1, 2] then
    $tailX += dx <=> 0
    $tailY += dy <=> 0
  else 
    puts "Unknown: (#{dx}, #{dy})"
    raise 
  end

  $tailPositions.add [$tailX, $tailY]
end


def run count
  $headX = 0
  $headY = 0
  $tailX = 0
  $tailY = 0

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


