class DevSystem::ShellGenerator < DevSystem::SimpleGenerator
  
  # liza g shell name place=app

  def call_default
    @controller_class = Shell

    name!
    place!

    create_controller @name, @controller_class, @place, @path do |unit, test|
      unit.section :controller_section_1, caption: "#{@class_name}.call({action: \"list\"})"
      unit.section :controller_section_2, caption: "#{@class_name}._call_sub_method_a({})"
      unit.section :controller_section_3, caption: "#{@class_name}._call_sub_method_b({})"
      unit.section :controller_section_list,   caption: "#{@class_name}.call_list({})"
      unit.section :controller_section_create, caption: "#{@class_name}.call_create({})"
      unit.section :controller_section_read,   caption: "#{@class_name}.call_read({})"
      unit.section :controller_section_update, caption: "#{@class_name}.call_update({})"
      unit.section :controller_section_delete, caption: "#{@class_name}.call_delete({})"

      test.section :controller_test_section_1
    end
  end

  # liza g shell:examples

  def call_examples
    copy_examples Shell
  end

end

__END__

# view controller_section_1.rb.erb

  def self.call(env)
    super

    method_name = "call_#{env[:action]}"
    if respond_to? method_name
      # before
      _call_sub_method_a env

      # action
      public_send method_name, env

      # after
      _call_sub_method_b env
      return
    end

    log "action not found: #{method_name.inspect}"
    raise NoMethodError, "action not found: #{method_name.inspect}"
  end

# view controller_section_2.rb.erb
  
  def self._call_sub_method_a(env)
    # your code here
  end
# view controller_section_3.rb.erb

  def self._call_sub_method_b(env)
    # your code here
  end

# view controller_section_list.rb.erb

  def self.call_list(env)
    # your code here
  end

# view controller_section_create.rb.erb

  def self.call_create(env)
    # your code here
  end

# view controller_section_read.rb.erb

  def self.call_read(env)
    # your code here
  end

# view controller_section_update.rb.erb

  def self.call_update(env)
    # your code here
  end

# view controller_section_delete.rb.erb

  def self.call_delete(env)
    # your code here
  end

# view controller_test_section_1.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end
