class DevSystem::ControllerGenerator < DevSystem::SimpleGenerator

  section :filters

  def before
    super
    params.add_field :require, default: "none"
    params.add_field :division, :boolean, default: false
    params.add_field :prefix, :boolean, default: false
    params.add_field :super
    params.expect 1, :string, validations: { string_size_min: 1 }
    params.add_field_range 2.., :string
    params.add_type :place, parse: false
    params.expect :place, :place

    def command.params_input_field_views(default, field_name)
      title = "Choose views"
      valid_views = generator.valid_views
      index_base_1 = valid_views.index(default) + 1 rescue 1
      InputShell.select title, valid_views, default: index_base_1
    end

    def command.params_input_field_1(default, field_name)
      title = "Name your new #{generator.super_controller.last_namespace}:"
      string = InputShell.ask title, default: default
      string = params_input_field_1(default, field_name) if string.to_s.strip.empty?
      string
    end

    def command.params_input_type_place(default, field_name)
      available_places = generator.available_places
      return available_places.keys[0] if available_places.count == 1

      options = available_places.map do |place, path|
        [
          "#{place.ljust 30} path: #{path}",
          place
        ]
      end.to_h
      InputShell.pick_one "Where should the controller be placed?", options
    end

  end

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
    @super_controller ||= Liza.const "#{params[:super]}_#{menv[:generator_name]}"
  end

  def controller_name
    @controller_name ||= begin
      name = arg_name
      
      if arg_place != "app"
        if params[:prefix]
          name = "#{arg_place.split("/").first}_#{name}"
        end
      end

      name
    end
  end

  def available_places
    @available_places ||= begin
      d = super_controller.division
      directory_name = params[:division] \
        ? "#{arg_name}_#{d.plural}"
        : d.plural
      log "directory_name: #{directory_name}"
      ControllerShell.places_for(d, directory_name: directory_name)
    end
  end

  def requirements_to_add
    @requirements_to_add ||= begin
      array = params[:require].to_s.split(",").map(&:strip).reject(&:empty?)
      array = [] if array == ["none"]
      array
    end
  end

  section :arguments

  def arg_name() = @arg_name ||= params[1]

  def arg_action_names() = @arg_action_names ||= params[2..]

  def arg_place() = @arg_place ||= params[:place]

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
            App.systems_directory.join "#{system_name}_system/#{super_controller.division.plural}"
          else
            App.systems_directory.join "#{system_name}_system/subsystems/#{subsystem_name}/#{super_controller.division.plural}"
          end
        end
      log "#{msg}. #{path}"
      path
    end
  end

  section :defaults_and_inputs

  def self.set_default_division(division)= before_instance_call :set_default_division, division

  def self.set_default_require(string)= before_instance_call :set_default_require, string

  def set_default_super(zuper)
    params.set_default :super, zuper

    log stick :white, :red, "Checking if class exists... #{params[:super]}_#{menv[:generator_name]}"
    Liza.const "#{zuper}_#{menv[:generator_name]}"
  end

  def set_default_division(division)
    params.set_default :division, division
  end

  def set_default_require(string)
    params.set_default :require, string
  end

end
