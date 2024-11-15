class WebSystem::RequestGenerator < DevSystem::ControllerGenerator

  section :actions
  
  # liza g request name action_1 action_2 action_3 place=app views=adjacent

  def call_default
    call_simple
  end

  # liza g request:simple name
  
  def call_simple
    set_default_super "simple"
    set_default_require ""
    set_default_views "adjacent"

    create_controller do |unit, test|
      unit.section name: :actions, render_key: :simple_actions
      arg_action_names.each do |action_name|
        unit.view name: action_name, render_key: :simple_view, format: :html
      end
      test.section name: :test
    end
  end

  # liza g request:base name

  def call_base
    set_default_super "base"
    set_default_require ""

    create_controller do |unit, test|
      unit.section name: :base
      test.section name: :test
    end
  end

end
