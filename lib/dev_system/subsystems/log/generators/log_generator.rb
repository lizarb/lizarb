class DevSystem::LogGenerator < DevSystem::SimpleGenerator
  
  # liza g log name place=app

  def call_default
    @controller_class = Log

    name!
    place!

    create_controller @name, @controller_class, @place, @path do |unit, test|
      unit.section :controller_section_1
      test.section :controller_test_section_1
    end
  end
  
  # liza g log:handler name place=app

  def call_handler
    @controller_class = HandlerLog

    name!
    place!
    append_handler_to_log_panel

    create_controller @name, @controller_class, @place, @path do |unit, test|
      unit.section :handler_section_1
      test.section :handler_test_section_1
    end
  end

  def append_handler_to_log_panel
    file = TextFileShell.new App.path.join("dev_box.rb")
    
    lines = LineShell.extract_wall_of file.old_lines, "    handler :"
    lines << "    handler :#{@name}\n"
    file.new_lines = LineShell.replace_wall_of file.old_lines, "    handler :", lines

    add_change file
  end

  # liza g log:examples

  def call_examples
    # TODO: append once per example
    @name = "logger"
    append_handler_to_log_panel
    #
    copy_examples Log
  end

end

__END__

# view controller_section_1.rb.erb

  def self.call(env)
    super
    env[:object_parsed] = env[:object].to_s
    true
  end

# view controller_test_section_1.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end

# view handler_section_1.rb.erb

  # TODO: https://rubyapi.org/3.1/o/logger
  def self.call(env)
    super
    Kernel.puts env[:object_parsed]
    true
  end

# view handler_test_section_1.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end
