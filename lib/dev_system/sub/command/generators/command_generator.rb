class DevSystem::CommandGenerator < DevSystem::SimpleGenerator

  # liza g command name place=app

  def call_default
    @controller_class = Command

    name!
    place!
    @args = Array command.simple_args[1..-1]

    ancestor = SimpleCommand
    create_controller @name, @controller_class, @place, @path, ancestor: ancestor do |unit, test|
      unit.section :controller_section_1
      test.section :controller_test_section_1
    end
  end
  
  # liza g command:examples

  def call_examples
    copy_examples Command
  end
  
end

__END__

# view controller_section_1.rb.erb

  # liza <%= @name %> a b c

  def call_default
    log :lower, "env.count is #{env.count}"

    log :lower, "args is #{env[:args].inspect}"
    log "simple_args is #{simple_args.inspect}"

    log stick :b, :<%= ColorShell.colors.keys.sample %>, "I just think Ruby is the Best for coding!"

    log "done at #{Time.now}"
    # 
  end

<% @args.each do |arg| -%>
  # liza <%= @name %>:<%= arg %> a b c

  def call_<%= arg %>
    log :lower, "env.count is #{env.count}"

    log :lower, "args is #{env[:args].inspect}"
    log "simple_args is #{simple_args.inspect}"

    log stick :b, :<%= ColorShell.colors.keys.sample %>, "I just think Ruby is the Best for coding!"

    log "done at #{Time.now}"
    # 
  end

<% end -%>
# view controller_test_section_1.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end
