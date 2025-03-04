class DevSystem::SystemGenerator < DevSystem::SimpleGenerator

  # liza g system name color=coral

  def call_default
    
    create_system
    create_system_box
    append_system_to_app
    create_app_box
    create_command
  end

  # liza g system:gemspec name
  def call_gemspec
    @rake_version = Gem::Specification.find_by_name("rake").version.to_s
    create_file "#{gem_name}.gemspec", :gemspec, :rb
  end

  private

  section :name

  set_input_arg 1 do |default|
    title = "New systems must have two names:"
    InputShell.ask title, default: default
  end
  
  def system_name() = @system_name ||= arg_name

  def gem_name() = "#{system_name}_system"

  def arg_name
    @arg_name ||= begin
      index = 1
      name = command.given_args[index]
      name_words = name.to_s.strip.split("_")
      # until name.to_s.strip.size.positive?
      until name_words.count > 1
        default = nil
        # prefix "my" if the given a single word
        default = "my_#{name}" if name_words.count == 1
        # establish a default name
        default ||= "my_#{get_random_name}"
        # hacks the input block
        value = instance_exec(default, &input_args[index])
        # hacks the command's args
        command.env[:simple_args][index] = value
        # sets name, used by the above `until` loop
        name = value
        name_words = name.to_s.strip.split("_")
      end
      name
    end
  end

  def get_random_name
    %w[
    crocodile chameleon gecko snake turtle
    axolotl salamander tree_frogs toads frogs
    crow eagle penguin owl hummingbird
    rhinoceros camel horse zebra hippo
    bull sheep antelope giraffe elk
    squirrel beaver capybara rat hamster
    lion tiger caracal meerkat hyena
    kangaroo koala tasmanian_devil opossum glider
    anteater sloth armadillo seacow elephant
    lemur baboon gibbon capuchin
    ].sample
  end
  
  def color() = @color ||= command.simple_color(:color, string: "#{system_name.camelize}System")

  section :sub_methods

  def append_system_to_app
    contents = read_file App.filename

    old_lines = contents.split("\n")
    lines = LineShell.extract_wall_of old_lines, "  system :"
    lines << "  system :#{system_name}"
    new_lines = LineShell.replace_wall_of old_lines, "  system :", lines

    contents = new_lines.join("\n")
    update_file App.filename, contents
  end

  def create_system
    unit, test = UnitHelper.new, UnitHelper.new
    unit_classes = ["#{system_name.camelize}System", "Liza::System"]
    test_classes = ["#{system_name.camelize}System::#{system_name.camelize}SystemTest", "Liza::SystemTest"]
    unit_path = App.systems_directory / "#{system_name.snakecase}_system.rb"
    test_path = App.systems_directory / "#{system_name.snakecase}_system" / "#{system_name.snakecase}_system_test.rb"

    log stick system.color, "Creating system: #{system_name}"

    unit.section name: :default, render_key: :section_system_default
    unit.section name: :info, render_key: :section_system_info
    test.section name: :systemic, render_key: :section_system_test

    add_unit unit, unit_classes, unit_path
    add_unit test, test_classes, test_path
  end

  def create_system_box
    unit, test = UnitHelper.new, UnitHelper.new
    unit_classes = ["#{system_name.camelize}System::#{system_name.camelize}Box", "Liza::Box"]
    test_classes = ["#{system_name.camelize}System::#{system_name.camelize}BoxTest", "Liza::BoxTest"]
    unit_path = App.systems_directory / "#{system_name.snakecase}_system" / "#{system_name.snakecase}_box.rb"
    test_path = App.systems_directory / "#{system_name.snakecase}_system" / "#{system_name.snakecase}_box_test.rb"

    unit.section name: :preconfiguration, render_key: :section_system_box_settings
    test.section name: :systemic, render_key: :section_system_box_test

    add_unit unit, unit_classes, unit_path
    add_unit test, test_classes, test_path
  end

  def create_app_box
    unit = UnitHelper.new
    classes = ["#{system_name.camelize}Box", "#{system_name.camelize}System::#{system_name.camelize}Box"]
    path = App.directory / "#{system_name.snakecase}_box.rb"
    
    unit.section name: :configuration, render_key: :section_app_box_settings

    add_unit unit, classes, path
  end

  def create_command
    generate %w[command -prefix], system_name, "place=#{system_name}"
  end

end
