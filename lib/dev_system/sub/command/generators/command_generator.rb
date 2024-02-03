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
    @args = Array command.simple_args[1..-1]

    ancestor = SimpleCommand
    create_controller @name, @controller_class, @place, @path, ancestor: ancestor do |unit, test|
      unit.section :controller_section_1,
        caption: "liza #{ @name }",
        method_name: "default"
      
      @args.each.with_index do |arg, i|
        unit.section :controller_section_1,
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
    @args = Array command.simple_args[1..-1]

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

# view controller_section_1.rb.erb

  def call_<%= @current_section[:method_name] %>
    log :higher, "args is #{ args.inspect }"
    log "simple_args is #{ simple_args.inspect }"

    log stick :b, :<%= ColorShell.colors.keys.sample %>, "I just think Ruby is the Best for coding!"

    log "done at #{ Time.now }"
  end

# view base_command_section_1.rb.erb

  def self.call(env)
    log :higher, "args is #{ args.inspect }"

    log stick :b, :<%= ColorShell.colors.keys.sample %>, "I just think Ruby is the Best for coding!"

    log "done at #{ Time.now }"
  end

# view controller_test_section_1.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end
