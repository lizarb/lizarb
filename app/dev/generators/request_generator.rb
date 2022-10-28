class RequestGenerator < Liza::Generator
  main_dsl

  FOLDER = "app/web/requests"

  generate :controller do
    folder "app/web/requests"
    filename "#{name}_request.rb"
    content request_content name
  end

  generate :controller_test do
    folder "app/web/requests"
    filename "#{name}_request_test.rb"
    content request_test_content name
  end

  # helper methods

  def request_content name
    <<~CODE
class #{name.camelize}Request < Liza::Request

  def self.call env
    path = env["REQUEST_PATH"]
    log :higher, "Called \#{self}.\#{__method__} with path \#{path}"

    #

    status = 200
    headers = {
      "Framework" => "Liza \#{Lizarb::VERSION}"
    }
    body = "It works!"

    #

    log status
    [status, headers, [body]]
  end

end
    CODE
  end

  def request_test_content name
    <<~CODE
class #{name.camelize}RequestTest < Liza::RequestTest

  test :subject_class do
    assert subject_class == #{name.camelize}Request
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :blue
  end

end
    CODE
  end

end
