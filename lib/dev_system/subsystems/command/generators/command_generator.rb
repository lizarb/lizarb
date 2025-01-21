class DevSystem::CommandGenerator < DevSystem::ControllerGenerator

  def before_create_controller
    super

    command.set_boolean :rescue_from, false, "Do you want to add a rescue_from method? (centralized rescue for Exception subclasses)"
  end

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
      @should_add_rescue_from = command.simple_boolean(:rescue_from)

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

  def random_sleep_float
    @sleepers ||= [
      *[0.1] * 9,
      *[0.2] * 7,
      *[0.3] * 5,
      *[0.4] * 3,
      *[0.5] * 1,
    ].shuffle
    @sleepers.shift
  end

end
