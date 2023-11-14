class DevSystem::ShellGenerator < DevSystem::SimpleGenerator
  
  # liza g shell name place=app

  def call_default
    @controller_class = Shell

    name!
    place!

    create_controller @name, @controller_class, @place, @path do |unit, test|
      unit.section :controller_section_1, caption: "#{@class_name}.call('sum', 1, 2)"
      unit.section :controller_section_2, caption: "#{@class_name}.sum(1, 2)"
      unit.section :controller_section_3, caption: "#{@class_name}.sub(1, 2)"
      test.section :controller_test_section_1
      test.section :controller_test_section_2
      test.section :controller_test_section_3
    end
  end

  # liza g shell:examples

  def call_examples
    copy_examples Shell
  end

end

__END__

# view controller_section_1.rb.erb

  def self.call(a, b, c)
    return sum(b, c) if a == "sum"
    return sub(b, c) if a == "sub"
    
    raise Error, "invalid a: #{a}"
  end
# view controller_section_2.rb.erb
  
    def self.sum(a, b)
      a + b
    end
# view controller_section_3.rb.erb

  def self.sub(a, b)
    a - b
  end
# view controller_test_section_1.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end
# view controller_test_section_2.rb.erb

  test :subject_class, :sum do
    a = subject_class.sum 1, 2
    b = 3
    assert_equality a, b
  end
# view controller_test_section_3.rb.erb

  test :subject_class, :sub do
    a = subject_class.sub 1, 2
    b = -1
    assert_equality a, b
  end