class DevSystem::ShellGenerator < DevSystem::ControllerGenerator

  def before
    super
    default_methods = %w[load,dump read,write import,export serialize,deserialize].sample
    family_name = super_controller.last_namespace

    command.set_boolean :helpers, false, "Do you want to add helpers? (methods and class for your customization)"
    command.set_boolean :instance, false, "Do you also want to use the instance-level of your #{family_name}?"

    command.set_string :helper, "helper", "What do you want to name your helper?"
    command.set_string :methods, default_methods, "What methods do you want to add to your helper? (comma,separated)"
    command.set_string :accessors, "", "What accessors do you want to add to your #{family_name}? (comma,separated)"
  end

  section :actions
  
  # liza g shell name place=app

  def call_default
    create_controller do |unit, test|
      arg_action_names.each do |action_name|
        unit.section name: :"action_#{action_name}", render_key: :actions, action: action_name
      end

      add_helpers_to_controller(unit, test) if command.simple_boolean(:helpers)
      add_instance_to_controller(unit, test) if command.simple_boolean(:instance)

      arg_action_names.each do |action_name|
        unit.view name: action_name, render_key: :view_simple, format: :txt
      end

      test.section name: :subject
    end
  end

  def add_helpers_to_controller(unit, test)
    unit.section name: :helpers
  end

  def add_instance_to_controller(unit, test)
    unit.section name: :instance
    log "+instance, setting default views to eof"
    set_default_views "eof"
  end

  # liza g shell:examples

  def call_examples
    copy_examples Shell
  end

  section :arg_helper

  def helper_name() = @helper_name ||= arg_helper

  def arg_helper() = @arg_helper ||= command.simple_string(:helper)

  section :arg_methods

  def the_methods() = @the_methods ||= arg_methods.split(",")

  def arg_methods() = @arg_methods ||= command.simple_string(:methods)

  section :arg_accessors

  def the_accessors() = @the_accessors ||= arg_accessors.split(",")

  def arg_accessors() = @arg_accessors ||= command.simple_string(:accessors)

end
