class DevSystem::ControllerGenerator < DevSystem::SimpleGenerator

  section :actions

  # liza g controller
  
  def call_default
    log stick :red, "Did you mean to generate a command instead?"
  end

  section :creating
  
  def create_controller(&block)
    before_create_controller
    log "super_controller: #{super_controller}"
    
    log "Determining class name..."
    @class_name = "#{controller_name.camelize}#{super_controller.division.last_namespace}"
    @class_name = "#{arg_place.split("/").first.camelize}System::#{@class_name}" unless arg_place == "app"
    log "class_name: #{@class_name}"

    unit, test = UnitHelper.new, UnitHelper.new
    log "Yielding..."
    yield unit, test

    log "Determining unit and test classes names..."
    unit_classes_names = [@class_name, super_controller.to_s]
    test_classes_names = unit_classes_names.map { "#{_1}Test" }
    log "unit_classes_names: #{unit_classes_names}"
    log "test_classes_names: #{test_classes_names}"

    log "Determining unit and test paths..."
    directory = App.root.join(arg_place_path)
    unit_path = directory.join("#{controller_name}_#{super_controller.division.singular}.rb")
    test_path = directory.join("#{controller_name}_#{super_controller.division.singular}_test.rb")
    log "unit_path: #{unit_path}"
    log "test_path: #{test_path}"

    log "Adding unit and test..."
    add_unit unit, unit_classes_names, unit_path
    add_unit test, test_classes_names, test_path

    unless arg_views_eof?
      log "Adding views..."
      arg_action_names.each do |arg|
        [unit, test].each do |u|
          u.views.each do |view|
            view_path = nil
            view_path = directory.join "#{controller_name}_#{super_controller.division.singular}#{"_test" if u == test}.rb.#{view[:name]}.#{view[:format]}.erb" if arg_views_adjacent?
            view_path = directory.join "#{controller_name}_#{super_controller.division.singular}#{"_test" if u == test}/#{view[:name]}.#{view[:format]}.erb" if arg_views_nested?
            add_view u, view, view_path if view_path
          end
        end
      end
    end
  end
 
  def before_create_controller
    # placeholder
  end

  def super_controller
    @super_controller ||= Liza.const "#{arg_super}_#{env[:generator_name]}"
  end

  def controller_name
    @controller_name ||= begin
      name = arg_name
      
      if arg_place != "app"
        if arg_prefix
          name = "#{arg_place.split("/").first}_#{name}"
        end
      end

      name
    end
  end

  def available_places
    @available_places ||= begin
      d = super_controller.division
      directory_name = arg_division \
        ? "#{arg_name}_#{d.plural}"
        : d.plural
      log "directory_name: #{directory_name}"
      ControllerShell.places_for(d, directory_name: directory_name)
    end
  end

  def requirements_to_add
    @requirements_to_add ||= begin
      array = arg_require.to_s.split(",").map(&:strip).reject(&:empty?)
      array = [] if array == ["none"]
      array
    end
  end

  section :arguments

  def arg_name() = @arg_name ||= (name = command.simple_arg(1) until name.to_s.strip.length.positive?; name)

  def arg_action_names() = @arg_action_names ||= command.simple_args_from_2

  def arg_place() = @arg_place ||= command.simple_string(:place)

  def arg_place_path
    @arg_place_path ||= begin
      path = 
        if available_places.key? arg_place
          msg = "the place already exists"
          available_places[arg_place]
        else
          msg = "infering the path"
          system_name, subsystem_name = arg_place.split("/")
          if subsystem_name.nil?
            App.systems_directory.join "#{system_name}_system"
          else
            App.systems_directory.join "#{system_name}_system/subsystems/#{subsystem_name}/#{super_controller.division.plural}"
          end
        end
      log "#{msg}. #{path}"
      path
    end
  end

  def arg_require() = @arg_require ||= command.simple_string(:require)
    
  def arg_division() = @arg_division ||= command.simple_boolean(:division)

  def arg_prefix() = @arg_prefix ||= command.simple_boolean(:prefix)

  def arg_super() = @arg_super ||= command.simple_string(:super)

  section :defaults_and_inputs

  def self.set_default_ask(ask)= before_instance_call :set_default_ask, ask

  def self.set_default_super(zuper)= before_instance_call :set_default_super, zuper
  
  def self.set_default_prefix(prefix)= before_instance_call :set_default_prefix, prefix

  def self.set_default_division(division)= before_instance_call :set_default_division, division

  def self.set_default_require(string)= before_instance_call :set_default_require, string
  
  def set_default_ask(ask)
    command.set_default_boolean :ask, ask
  end

  def set_default_prefix(prefix)
    command.set_default_boolean :prefix, prefix
  end

  def set_default_super(zuper)
    command.set_default_string :super, zuper
    log stick :white, :red, "Checking if class exists... #{arg_super}_#{env[:generator_name]}"
    Liza.const "#{zuper}_#{env[:generator_name]}"
  end

  def set_default_division(division)
    command.set_default_boolean :division, division
  end

  def set_default_require(string)
    command.set_default_string :require, string    
  end

  set_input_arg 1 do |default|
    title = "Name your new #{env[:generator].super_controller.last_namespace}:"
    x = InputShell.ask title, default: default
    redo if x.to_s.strip.empty?
    x
  end
  
  set_input_boolean :division do |default|
    title = "Create a new division?"
    InputShell.yes? title, default: !!default
  end

  set_input_boolean :prefix do |default|
    title = "Do you want to prefix your controllers with their system names?"
    InputShell.yes? title, default: !!default
  end

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
      InputShell.pick_one "Where should the controller be placed?", options
    end
    place
  end

  set_input_string :require do |default|
    title = "Want to require any gems? (comma separated)"
    InputShell.ask title, default: default
  end

  set_default_division false
  set_default_require "none"

end
