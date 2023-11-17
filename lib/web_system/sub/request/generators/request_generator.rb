class WebSystem::RequestGenerator < DevSystem::SimpleGenerator

  # liza g request name place=app

  def call_default
    @controller_class = Request

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

  def self.call(env)
    path = env["REQUEST_PATH"]

    status = 200
    headers = {
      "Framework" => "Liza \#{Lizarb::VERSION}"
    }
    body = "It works! <%= @name.camelize %>Request"

    [status, headers, [body]]
  end

# view controller_test_section_1.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end
