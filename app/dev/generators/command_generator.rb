class CommandGenerator < Liza::Generator
  main_dsl

  FOLDER = "app/dev/commands"

  generate :controller do
    folder FOLDER
    filename "#{name}_command.rb"
    content command_content
  end

  generate :controller_test do
    folder FOLDER
    filename "#{name}_command_test.rb"
    content command_test_content
  end

  # helper methods

  def command_content
    <<~CODE
class #{name.camelize}Command < Liza::Command

  def self.call args
    log :higher, "Called \#{self}.\#{__method__} with args \#{args}"

    #
  end

end
    CODE
  end

  def command_test_content
    <<~CODE
class #{name.camelize}CommandTest < Liza::CommandTest

  test :subject_class do
    assert subject_class == #{name.camelize}Command
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

end
    CODE
  end

end
