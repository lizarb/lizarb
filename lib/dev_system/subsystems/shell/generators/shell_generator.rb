class DevSystem::ShellGenerator < DevSystem::SimpleGenerator
  
  # liza g shell name place=app

  def call_default
    @controller_class = Shell

    name!
    place!

    actions = command.simple_args_from_2
    actions = %w(list create read update delete) if actions.empty?

    create_controller @name, @controller_class, @place, @path do |unit, test|
      unit.section :controller_section_require, caption: "Required lazily on call"

      actions.each do |action|
        unit.section :controller_section_action, caption: "#{@class_name}.#{ action }()", action: action
      end

      unit.section :controller_section_1, caption: "#{@class_name}.call({action: :list})"
      unit.section :controller_section_2, caption: "#{@class_name}.before_action({})"
      unit.section :controller_section_3, caption: "#{@class_name}.after_action({})"

      actions.each do |action|
        unit.section :controller_section_call_action, caption: "#{@class_name}.call_#{ action }({})", action: action
      end

      test.section :controller_test_section_1
    end
  end

  # liza g shell:examples

  def call_examples
    copy_examples Shell
  end

end

__END__

# view controller_section_require.rb.erb
  # require "<%= @name %>"
# view controller_section_action.rb.erb

  def self.<%= @current_section[:action] %>()
    # your code here
    call action: :<%= @current_section[:action] %>
    # your code here
  end
# view controller_section_1.rb.erb

  # def self.call(env)
  #   super

  #   method_name = "call_#{env[:action]}"
  #   if respond_to? method_name
  #     before_action env
  #     public_send method_name, env
  #     after_action env
  #     return
  #   end

  #   msg = "Method not found: #{method_name.inspect}"
  #   log msg
  #   raise NoMethodError, msg
  # end
# view controller_section_2.rb.erb
  
  # def self.before_action(env)
  #   # your code here
  # end
# view controller_section_3.rb.erb

  # def self.after_action(env)
  #   # your code here
  # end
# view controller_section_call_action.rb.erb

  # def self.call_<%= @current_section[:action] %>(env)
  #   # your code here
  # end
# view controller_test_section_1.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end
