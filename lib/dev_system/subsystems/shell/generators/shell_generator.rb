class DevSystem::ShellGenerator < DevSystem::ControllerGenerator
  
  section :actions
  
  # liza g shell name place=app

  def call_default
    create_controller do |unit, test|
      arg_action_names.each do |action_name|
        unit.section name: :actions, action: action_name
      end
      unit.section name: :controller
      test.section name: :subject
    end
  end

  # liza g shell:examples

  def call_examples
    copy_examples Shell
  end

end
