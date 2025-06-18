class PrimeSystem::EpicGenerator < DevSystem::ControllerGenerator


  section :actions

  # set_default_views "none"
  # set_default_views "eof"
  # set_default_views "adjacent"
  # set_default_views "nested"

  # liza g epic name action_1 action_2 action_3
  def call_default
    set_default_super ""

    create_controller do |unit, test|
      unit.section name: :actions, render_key: :section_default_actions

      arg_action_names.each do |action_name|
        unit.view name: action_name, render_key: :view_default, format: :txt
      end unless arg_views_none?

      test.section name: :subject
    end
  end

end
