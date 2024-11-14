class DevSystem::SubsystemGenerator < DevSystem::SimpleGenerator

  section :actions

  # liza g subsystem name
  def call_default
    name = arg_name

    if App.systems.values.map(&:subs).flatten.map(&:to_s).include? name
      log stick :red, :white, :b, "controller and panel #{name} already exist"
      return
    end

    add_sub_to_system
    add_panel_to_box
    create_controller_panel
  end

  section :submethods

  def add_sub_to_system
    contents = read_file system_path
    old_lines = contents.split("\n")

    lines = LineShell.extract_between old_lines, "class ".."end"
    lines << "  panel :#{subsystem_name}"
    lines = LineShell.replace_between old_lines, "class ".."end", lines

    contents = lines.join("\n")
    update_file system_path, contents
  end

  def add_panel_to_box
    path = App.systems_directory / "#{system_name}_system/#{system_name}_box.rb"
    contents = read_file path
    contents = _add_panel_to_box path, contents, "preconfigure"
    update_file path, contents

    path = App.directory / "#{system_name}_box.rb"
    
    contents = read_file path
    return if contents.empty?
    contents = _add_panel_to_box path, contents, "configure"
    update_file path, contents
  end

  def _add_panel_to_box path, contents, verb
    a = contents.split("\n")
    a = a.map { _1.strip }
    a = a.select { _1.start_with? "  #{verb} :" }

    # contents

    old_lines = contents.split("\n")

    generic_panel_line = "  #{verb} :"

    new_lines = [
      "  #{verb} :#{subsystem_name} do",
      "    # #{subsystem_name.camelcase}Panel.instance gives you read-access to this instance",
      "  end",
      "",
    ]

    lines = LineShell.extract_between old_lines, "class ".."end"
    if a.count == 0
      lines += new_lines
    else
      panel_lines = LineShell.extract_wall_of lines, generic_panel_line
      panel_lines += new_lines
      panel_lines = panel_lines.sort
      lines = LineShell.replace_wall_of lines, generic_panel_line, panel_lines
    end

    lines = LineShell.replace_between old_lines, "class ".."end", lines

    lines.join("\n")
  end

  def create_controller_panel
    class_name = "#{system_name.to_s.camelize}System::#{subsystem_name.to_s.camelize}"

    # build

    controller      = UnitHelper.new
    controller_test = UnitHelper.new
    panel           = UnitHelper.new
    panel_test      = UnitHelper.new

    controller.section        name: :subsystem, render_key: :section_controller,      format: :rb
    controller_test.section   name: :subject,   render_key: :section_controller_test
    panel.section             name: :subsystem, render_key: :section_panel,           format: :rb
    panel_test.section        name: :subject,   render_key: :section_panel_test

    controller_class_names      = ["#{class_name}",          "Liza::Controller"]
    controller_test_class_names = ["#{class_name}Test",      "Liza::ControllerTest"]
    panel_class_names           = ["#{class_name}Panel",     "Liza::Panel"]
    panel_test_class_names      = ["#{class_name}PanelTest", "Liza::PanelTest"]

    controller_path      = subsystem_path / "#{subsystem_name}.rb"
    controller_test_path = subsystem_path / "#{subsystem_name}_test.rb"
    panel_path           = subsystem_path / "#{subsystem_name}_panel.rb"
    panel_test_path      = subsystem_path / "#{subsystem_name}_panel_test.rb"

    # render and add

    _create_controller_panel_unit(
      controller,
      controller_class_names,
      controller_path
    )
    
    _create_controller_panel_unit(
      controller_test,
      controller_test_class_names,
      controller_test_path
    )
    
    _create_controller_panel_unit(
      panel,
      panel_class_names,
      panel_path
    )
    
    _create_controller_panel_unit(
      panel_test,
      panel_test_class_names,
      panel_test_path
    )
  end

  def _create_controller_panel_unit(unit, class_names, path)
    log "Adding unit..."
    log "unit: #{unit.inspect}"
    log "class_names: #{class_names}"
    log "path: #{path.inspect}"

    add_unit unit, class_names, path
  end

  section :helpers

  def arg_name() = @arg_name ||= (name = command.simple_arg(1) until name.to_s.strip.length.positive?; name)

  def system_name() = arg_place
  
  def system_path() = @system_path ||= (App.systems_directory / "#{system_name}_system.rb")
  
  def subsystem_name() = arg_name

  def subsystem_path() = @subsystem_path ||= (App.root / arg_place_path)
  
  def available_places() = @available_places ||= ControllerShell.places_for_systems(arg_name)

  def arg_place_system() = App.systems[arg_place.to_sym]

  def arg_place() = @arg_place ||= command.simple_string(:place)

  def arg_place_path() = @arg_place_path ||= ControllerShell.path_for(arg_place, arg_name)
  
  set_input_string :place do |default|
    available_places = env[:generator].available_places
    place = nil
    place = available_places.keys[0] if available_places.count == 1
    place ||= begin
      options = available_places.map do |place, path|
        [
          "#{place.ljust 30} path: #{path}",
          place
        ]
      end.to_h
      TtyInputCommand.pick_one "Where should the controller be placed?", options
    end
    place
  end

end
