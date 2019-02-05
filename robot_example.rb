class RobotExample

  def initialize(table_dimensions: [5,5])
    require 'pry'
    @x_axis_range = (0..table_dimensions[0] - 1)
    @y_axis_range = (0..table_dimensions[1] - 1)

    @report = {x_axis: 0, y_axis: 0, facing: "NORTH"}
    print "Enter commands (ending with a tab): "
    commands = gets("\t\n").chomp.gsub(/\n/, '|').gsub(/\t/, '').split('|').map(&:upcase)
    operate_command commands
  end

  def operate_command command_set
    command_set.map do |command|
      case command.strip
        when /(PLACE)\s[0-4],[0-4],((SOUTH)|(NORTH)|(EAST)|(WEST))/
          place_command = command.strip.split(' ')[1].split(',')
          @report = {x_axis: place_command[0], y_axis: place_command[1], facing: place_command[2].to_s}
        when 'LEFT'
          change_robot_position("left")
        when 'RIGHT'
          change_robot_position("right")
        when 'MOVE'
          change_robot_position("move")
        when 'REPORT'
          puts @report.values.join(',')
          print "Do you want to contitue? (press Y or N): "
          user_response = gets.gsub(/\n/, '')
          if user_response.upcase == "Y"
            RobotExample.new
          end
        else
          if command != ""
            puts "Please enter valid commands or Press Ctrl+C to exit."
            RobotExample.new
          end
      end
    end
  end
  def change_robot_position(action = "move")
    if @x_axis_range.include?(@report[:x_axis].to_i) && @y_axis_range.include?(@report[:y_axis].to_i)
      case action
        when "move"
          move_parameter = get_direction
          @report[:"#{move_parameter.keys[0]}"] = @report[:"#{move_parameter.keys[0]}"].to_i + move_parameter.values[0].to_i
        when "left"
          move_parameter = get_facing("LEFT")
          @report[move_parameter.keys[0]] = move_parameter.values[0]
        when "right"
          move_parameter = get_facing("RIGHT")
          @report[move_parameter.keys[0]] = move_parameter.values[0]
      end
    # else
    #   puts @report.values.join(',')
    #   puts "Wrong position"
    end
  end

  def get_direction
    case @report[:facing]
    when "NORTH"
      { y_axis: 1 }
    when "SOUTH"
      { y_axis: -1 }
    when "WEST"
      { x_axis: -1 }
    when "EAST"
      { x_axis: 1 }
    end
  end

  def get_facing(turn_towards)
    case @report[:facing]
      when "NORTH"
        { facing: (turn_towards == "LEFT" ? "WEST" : "EAST") }
      when "SOUTH"
        { facing: (turn_towards == "LEFT" ? "EAST" : "WEST") }
      when "WEST"
        { facing: (turn_towards == "LEFT" ? "SOUTH" : "NORTH") }
      when "EAST"
        { facing: (turn_towards == "LEFT" ? "NORTH" : "SOUTH") }
    end
  end


end
