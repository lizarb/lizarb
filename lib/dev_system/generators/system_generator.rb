class DevSystem::SystemGenerator < DevSystem::SimpleGenerator

  # liza g system name color=coral

  def call_default
    @name = command.simple_arg_ask_snakecase 1, "What is the name of the system you want to generate?"
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
    path    = App.sys_path.join "#{@name.snakecase}_system.rb"
    
    create_unit unit, classes, path, :system
  end

  def create_box
    unit, test = UnitHelper.new, UnitHelper.new
    unit_classes = ["#{@name.camelize}System::#{@name.camelize}Box", "Liza::Box"]
    test_classes = ["#{@name.camelize}System::#{@name.camelize}BoxTest", "Liza::BoxTest"]
    unit_path = App.sys_path.join "#{@name.snakecase}_system/#{@name.snakecase}_box.rb"
    test_path = App.sys_path.join "#{@name.snakecase}_system/#{@name.snakecase}_box_test.rb"

    @class_name = unit_classes[0]
    test.section :box_test_section_1, caption: ""
    
    create_unit unit, unit_classes, unit_path, :unit
    create_unit test, test_classes, test_path, :unit
  end

end

__END__

# view system.rb.erb
class <%= @class_names[0] %> < <%= @class_names[1] %>
  class Error < Liza::Error; end
  
  #

  color :<%= @color %>

end

# view box_test_section_1.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end
