class DevSystem::CommandGenerator < DevSystem::ControllerGenerator

  def self.call(args)
    log "args = #{args.inspect}"

    name = args.shift || raise("args[0] should contain NAME")
    name = name.snakecase

    placement = _ask_placement name
    log "placement = #{placement.inspect}"

    if placement.start_with? "app"
      _build_generators_for_app name, placement, args
    else
      _build_generators_for_system name, placement, args
    end.each do |generator|
      generator.generate!
    end
  end

  def self._ask_placement(name)
    systems = _get_writable_systems
    title = "Where do you want to place the file?"
    options = [$APP, *systems.keys].map(&:to_s)
    return options.first if options.size < 2

    DevBox.pick_one title, options
  end

  def self._get_writable_systems
    App.systems.select do |key, system|
      system.source_location_radical.start_with? Dir.pwd
    end
  end

  def self._build_generators_for_app(name, placement, args)
    ret = []

    ret << new.tap do |instance|
      instance.instance_exec do
        @name = name
        @class_name = "#{name.camelize}Command"
        @superclass_name = "Liza::Command"
        @template = :command
        @path = "#{placement}/dev/commands/#{name.snakecase}_command.rb"
        @args = args
      end
    end

    ret << new.tap do |instance|
      instance.instance_exec do
        @name = name
        @subject_class_name = "#{name.camelize}Command"
        @class_name = "#{name.camelize}CommandTest"
        @superclass_name = "Liza::CommandTest"
        @template = :command_test
        @path = "#{placement}/dev/commands/#{name.snakecase}_command_test.rb"
        @args = args
      end
    end

    ret
  end

  def self._build_generators_for_system(name, placement, args)
    ret = []

    system_name = "#{placement}_system"
    system = Liza.const system_name
    generated_class_name = "#{system}::#{name.camelize}Command"

    subsystem_name = _ask_subsystem_name(system, generated_class_name)
    log "subsystem_name = #{subsystem_name.inspect}"

    ret << new.tap do |instance|
      instance.instance_exec do
        @name = name
        @class_name = "#{system}::#{name.camelize}Command"
        @superclass_name = "DevSystem::Command"
        @template = :command
        @path = \
          if subsystem_name[0] == "/"
            "lib/#{system_name}/commands/#{name}_command.rb"
          else
            "lib/#{system_name}/sub/#{subsystem_name}/commands/#{name}_command.rb"
          end
        @args = args
      end
    end

    ret << new.tap do |instance|
      instance.instance_exec do
        @name = name
        @subject_class_name = "#{system}::#{name.camelize}Command"
        @class_name = "#{system}::#{name.camelize}CommandTest"
        @superclass_name = "DevSystem::CommandTest"
        @template = :command_test
        @path = \
          if subsystem_name[0] == "/"
            "lib/#{system_name}/commands/#{name}_command_test.rb"
          else
            "lib/#{system_name}/sub/#{subsystem_name}/commands/#{name}_command_test.rb"
          end
        @args = args
      end
    end

    ret
  end

  def self._ask_subsystem_name(system, generated_class_name)
    title = "Where do you want to place #{generated_class_name} ?"
    options = ["/ system root folder", *system.subs.keys].map(&:to_s)
    return options.first if options.size < 2

    DevBox.pick_one title, options
  end

  # lizarb command:install

  def self.install(args)
    log "args = #{args.inspect}"

    generators = _build_installer_generators(args)
    generators.each do |generator|
      generator.generate!
    end
  end

  def self._build_installer_generators(args)
    ret = []

    app_name = $APP

    ret << new.tap do |instance|
      instance.instance_exec do
        source = "#{Lizarb::GEM_DIR}/app_commands/dev/commands/narrative_method_command.rb"
        @content = TextShell.read source

        @path = "#{app_name}/dev/commands/narrative_method_command.rb"
        @args = args
      end
    end

    ret << new.tap do |instance|
      instance.instance_exec do
        source = "#{Lizarb::GEM_DIR}/app_commands/dev/commands/narrative_method_command_test.rb"
        @content = TextShell.read source

        @path = "#{app_name}/dev/commands/narrative_method_command_test.rb"
        @args = args
      end
    end

    ret
  end

  # lizarb command:examples

  def self.examples(args)
    log "args = #{args.inspect}"

    generators = _build_example_generators(args)
    generators.each do |generator|
      generator.generate!
    end
  end

  def self._build_example_generators(args)
    ret = []

    app_name = $APP

    list = Dir["#{Lizarb::GEM_DIR}/app_commands/dev/commands/*.rb"]
    list.each do |source|
      ret << new.tap do |instance|
        instance.instance_exec do
          @content = TextShell.read source

          fname = source.split("/").last

          @path = "#{app_name}/dev/commands/#{fname}"
          @args = args
        end
      end
    end

    ret
  end

  #

  def generate!
    @content ||= render :unit, @template, format: :rb
    TextShell.write @path, @content if _should_generate?
  end

  def _should_generate?
    must_ask_to_overwrite = File.exist? @path

    return true unless must_ask_to_overwrite

    _output_diff
    log "#{@path} already exists. #{"Do you want to overwrite?".underline}"

    title = "Do you want to overwrite #{@path} ?"
    options = ["Yes", "No"]

    x = DevBox.pick_one title, options
    x == "Yes"
  end

  def _output_diff
    log "current content".red.underline
    puts File.read(@path).red

    log "new content".green.underline
    puts @content.green
  end

  #

  def self.view args
    log "args = #{args.inspect}"

    name = args.shift || raise("args[0] should contain NAME")
    name = name.downcase

    new.generate_app_controller :dev, :command, :commands, name
  end

end

__END__

# view install_insert_panel.rb.erb

    short :b, :bench
    short :g, :generate

# view unit.rb.erb
class <%= @class_name %> < <%= @superclass_name %>
  <%= render -%>
end
# view command.rb.erb

  #

  # lizarb <%= @name %> a b c
  # lizarb <%= @name %>:call a b c
  def self.call args
    log "args = #{args.inspect}"

    # require "<%= @name %>"

    new.call args
  end
<% if @args.empty? %>
  # lizarb <%= @name %>#call a b c
  def call args
    log "@args = #{args.inspect}"
    @args = args

    log "I just think Ruby is the Best for coding!"

    log "done at #{Time.now}"
  end
<% else %>
  # lizarb <%= @name %>#call a b c
  def call args
    log "args = #{args.inspect}"

  <% @args.each do |arg| -%>
  <%= arg %> args
  <% end -%>

    log "done at #{Time.now}"
  end

<% @args.each do |arg| -%>
  # lizarb <%= @name %>#<%= arg %> a b c
  def <%= arg %> args
    log "  args = #{args.inspect}"

    log "  I just think Ruby is the Best for coding!".light_<%= [:green, :magenta, :red, :blue].sample %>

    log "  done at #{Time.now}"
  end

<% end -%>
<% end -%>
# view command_test.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @subject_class_name %>, subject_class
    assert_equality <%= @subject_class_name %>, subject.class
  end

  # test :subject_class, :call do
  #   a = 1
  #   b = 2
  #   assert_equality a, b
  # end
  #
  # test :subject, :call do
  #   a = 1
  #   b = 2
  #   assert_equality a, b
  # end
