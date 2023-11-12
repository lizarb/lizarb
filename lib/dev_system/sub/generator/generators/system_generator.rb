class DevSystem::SystemGenerator < DevSystem::SimpleGenerator

  # liza g system name color=coral

  def call_default
    @name = command.simple_arg_ask_snakecase 0, "What is the name of the system you want to generate?"
    log "@name = #{@name}"

    @color = command.simple_color :color, string: "#{@name.camelize}System"
    log "@color = #{@color}"

    append_system_to_app
    create_system
    create_box
  end

  private

  def append_system_to_app
    file = TextFileShell.new App.filename
    
    lines = LineShell.extract_wall_of file.old_lines, "  system :"
    lines << "  system :#{@name}\n"
    file.new_lines = LineShell.replace_wall_of file.old_lines, "  system :", lines

    add_change file
  end

  def create_system
    unit    = UnitHelper.new
    classes = ["#{@name.camelize}System", "Liza::System"]
    path    = App.root.join("lib/#{@name.snakecase}_system.rb")
    
    create_unit unit, classes, path, :system
  end

  def create_box
    unit = UnitHelper.new
    classes = ["#{@name.camelize}System::#{@name.camelize}Box", "Liza::Box"]
    path = App.root.join("lib/#{@name.snakecase}_system/#{@name.snakecase}_box.rb")
    
    create_unit unit, classes, path, :unit
  end

end

__END__

# view system.rb.erb
class <%= @class_names[0] %> < <%= @class_names[1] %>
  class Error < Liza::Error; end
  
  #

  color :<%= @color %>

end
