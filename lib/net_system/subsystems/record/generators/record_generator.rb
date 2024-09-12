class NetSystem::RecordGenerator < DevSystem::SimpleGenerator

  # liza g record name place=app

  def call_default
    @controller_class = Record

    name!
    place!

    @args = command.simple_args[1..-1]

    create_controller @name, @controller_class, @place, @path do |unit, test|
      unit.section :controller_section_1, caption: ""
      test.section :controller_test_section_1, caption: ""
    end
  end
  
end

__END__

# view controller_section_1.rb.erb

  db :sqlite
  set :table, :<%= @name %>s

# view controller_test_section_1.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end
