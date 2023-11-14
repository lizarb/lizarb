class DevSystem::GeneratorGenerator < DevSystem::SimpleGenerator

  # liza g generator name place=app 

  def call_default
    @controller_class = Generator
    
    name!
    place!

    ancestor = SimpleGenerator
    create_controller @name, @controller_class, @place, @path, ancestor: ancestor do |unit, test|
      unit.section :controller_section_1, caption: "liza g #{@name} name place=app"
      unit.section :controller_section_2, caption: "liza g #{@name}:examples"
      unit.view    :generator_view_1, key: :controller_section_1
      test.section :controller_test_section_1
    end
  end

end

__END__

# view controller_section_1.rb.erb

  def call_default
    @controller_class = <%= @name.camelize %>

    name!
    place!

    create_controller @name, @controller_class, @place, @path do |unit, test|
      unit.section :controller_section_1
      test.section :controller_test_section_1
    end
  end
# view controller_section_2.rb.erb

  # def call_examples
  #   copy_examples <%= @name.camelize %>
  # end
# view generator_view_1.rb.erb
  def self.call(env)
    # 
  end

<%= "#" %> view controller_test_section_1.rb.erb

  test :subject_class, :subject do
    assert_equality <%%= @class_name %>, subject_class
    assert_equality <%%= @class_name %>, subject.class
  end

  # test :subject_class, :call do
  #   a = 1
  #   b = 2
  #   assert_equality a, b
  # end
  #
  # test :subject, :call do
  #   a = 1
  #   b = 2
  #   assert_equality a, b
  # end

# view controller_test_section_1.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end
