require 'pry'

class Simulator


def instructions(text)
  commands = []
  text.upcase.chars.each do |action|
    case action
      when 'L'
        commands << :turn_left
      when 'R'
        commands << :turn_right
      when 'A'
        commands << :advance
    end
  end
    commands
end

def place(robot, placement = {})
  robo = robot
  robo.orient(placement[:direction])
  robo.at(placement[:x], placement[:y])
end

def evaluate(robot, commands)
  robo = robot
  actions = instructions(commands)
  actions.each do |move|
  robo.send(move)
  end
end

end

class Robot
  attr_accessor :bearing, :location

  TURN_RIGHT = {:north => :east, :east => :south, :south => :west, :west => :north}
  TURN_LEFT = {:north => :west, :east => :north, :south => :east, :west => :south}

  def initialize
    @bearing = :north
    @location = [0, 0]
  end  

  def orient(direction)
    unless %w(north south east west).include?(direction.to_s)
      raise ArgumentError.new("Only north, south, east or west are allowed")
    end
    self.bearing = direction
  end

  def at(eastwest, northsouth)
    location[0] = eastwest
    location[1] = northsouth
  end

  def coordinates
    self.location
  end

  def advance
    case bearing
    when :north
      location[1] += 1
    when :south
      location[1] -= 1
    when :east
      location[0] += 1
    when :west
      location[0] -= 1
    end
  end


  def turn_right
    self.bearing = TURN_RIGHT[bearing]
  end

  def turn_left
    self.bearing = TURN_LEFT[bearing]
  end


end

