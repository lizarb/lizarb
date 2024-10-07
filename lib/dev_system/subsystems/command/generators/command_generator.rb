class DevSystem::CommandGenerator < DevSystem::SimpleGenerator

  # liza g command name place=app

  def call_default
    call_simple
  end

  # liza g command:simple name place=app

  def call_simple
    @controller_class = Command

    name!
    place!
    @args = command.simple_args_from_2

    ancestor = SimpleCommand
    create_controller @name, @controller_class, @place, @path, ancestor: ancestor do |unit, test|
      unit.section :simple_command_section_1,
        caption: "filters"

      unit.section :simple_command_section_2,
        caption: "liza #{ @name } k1=v1 k3=v3 sa se si +a +b -c -d",
        method_name: "default"
      
      @args.each do |arg|
        unit.section :simple_command_section_3,
          caption: "liza #{ @name }:#{ arg }",
          method_name: arg
      end

      test.section :controller_test_section_1
    end
  end

  # liza g command:base name place=app

  def call_base
    @controller_class = Command

    name!
    place!
    @args = command.simple_args_from_2

    ancestor = BaseCommand
    create_controller @name, @controller_class, @place, @path, ancestor: ancestor do |unit, test|
      unit.section :base_command_section_1,
        caption: "liza #{ @name }"
      
      test.section :controller_test_section_1
    end
  end
  
  # liza g command:examples

  def call_examples
    copy_examples Command
  end
  
end

__END__

# view simple_command_section_1.rb.erb

  def before
    super
    @t = Time.now
    log "simple_args     #{ simple_args }"
    log "simple_strings  #{ simple_strings }"
    log "simple_booleans #{ simple_booleans }"
  end
  
  def after
    super
    log "#{ @t.diff }s | done"
  end
# view simple_command_section_2.rb.erb

  def call_<%= @current_section[:method_name] %>
    log stick :b, :<%= ColorShell.colors.keys.sample %>, "I just think Ruby is the Best for coding!"
<% @args.each do |arg| -%>
    call_<%= arg %>
<% end -%>
  end
# view simple_command_section_3.rb.erb

  def call_<%= @current_section[:method_name] %>
    log stick :b, :<%= ColorShell.colors.keys.sample %>, "I just think Ruby is the Best for coding!"
  end
# view base_command_section_1.rb.erb

  def self.call(env)
    super
    log "args is #{ args.inspect }"

    log stick :b, :<%= ColorShell.colors.keys.sample %>, "I just think Ruby is the Best for coding!"

    log "done at #{ Time.now }"
  end

# view controller_test_section_1.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end
