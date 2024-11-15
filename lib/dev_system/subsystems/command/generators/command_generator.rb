class DevSystem::CommandGenerator < DevSystem::ControllerGenerator

  section :default
  
  def arg_action_names
    ["default", *super]
  end

  section :actions

  # liza g command name place=app

  def call_default
    call_simple
  end

  # liza g command:simple name place=app

  def call_simple
    set_default_super "simple"
    
    create_controller do |unit, test|
      unit.section name: :filters, render_key: :section_simple_filters
      unit.section name: :actions, render_key: :section_simple_actions
      
      arg_action_names.each do |action_name|
        unit.view name: action_name, render_key: :view_simple, format: :txt
      end

      test.section name: :subject
    end
  end

  # liza g command:base name place=app

  def call_base
    set_default_super "base"
    
    create_controller do |unit, test|
      unit.section name: :section_base, skip_section: true
      test.section name: :subject
    end
    
  end
  
  # liza g command:examples

  def call_examples
    copy_examples Command
  end
  
end
