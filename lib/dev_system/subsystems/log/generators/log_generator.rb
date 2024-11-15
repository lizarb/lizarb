class DevSystem::LogGenerator < DevSystem::ControllerGenerator
  
  section :actions
  
  # liza g log name place=app

  def call_default
    set_default_super ""

    create_controller do |unit, test|
      unit.section name: :controller_section_1, skip_section: true
      test.section name: :controller_test_section_1, skip_section: true
    end
  end
  
  # liza g log:handler name place=app

  def call_handler
    set_default_super "handler"
    append_handler_to_log_panel

    create_controller do |unit, test|
      unit.section name: :handler_section_1, skip_section: true
      test.section name: :handler_test_section_1, skip_section: true
    end
  end

  def append_handler_to_log_panel
    path = App.directory.join "dev_box.rb"

    contents = read_file path
    old_lines = contents.split("\n")

    lines = LineShell.extract_wall_of old_lines, "    handler :"
    lines << "    handler :#{controller_name}"
    lines = LineShell.replace_wall_of old_lines, "    handler :", lines

    contents = lines.join("\n")
    update_file path, contents
  end

  # liza g log:examples

  def call_examples
    # This bypasses the name check
    @controller_name = "logger"
    append_handler_to_log_panel
    #
    copy_examples Log
  end

end
