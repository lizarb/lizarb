class DevSystem::GeneratorGenerator < DevSystem::ControllerGenerator

  section :default
  
  def arg_action_names()= @arg_action_names ||= ["default", *super]

  set_default_views "adjacent"

  set_default_string :format, "txt"
  set_input_string :format do |default|
    TtyInputCommand.prompt.ask "What format?", default: default
  end

  section :actions
  
  # liza g generator name place=app 

  def call_default
    call_simple
  end

  # liza g generator:controller

  def call_controller
    set_default_super "controller"
    set_default_require ""

    create_controller do |unit, test|
      format = command.simple_string :format
      unit.section name: :actions, render_key: :section_controller_actions, format: format

      arg_action_names.each do |action_name|
        unit.view name: "section_#{action_name}_actions", render_key: :view_controller_actions, format: :rb
        unit.view name: "view_#{action_name}", render_key: :view_controller_views, render_format: :txt, format: format
      end

      test.section name: :subject
    end
  end

  # liza g generator:simple format=txt

  def call_simple
    set_default_super "simple"
    set_default_require ""

    create_controller do |unit, test|
      format = command.simple_string :format
      unit.section name: :actions, render_key: :section_simple_actions, format: format
      test.section name: :subject

      arg_action_names.each do |action_name|
        unit.view name: action_name, render_key: :view_simple, render_format: "txt", format: format
      end
    end
  end

end
