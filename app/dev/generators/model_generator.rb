class ModelGenerator < Liza::Generator
  main_dsl

  FOLDER = "app/net/models"

  generate :controller do
    folder FOLDER
    filename "#{name}_model.rb"
    content model_content name
  end

  generate :controller_test do
    folder FOLDER
    filename "#{name}_model_test.rb"
    content model_test_content name
  end

  # helper methods

  def model_content name
    <<~CODE
class #{name.camelize}Model < AppModel
  set :table, :#{name}s

end
    CODE
  end

  def model_test_content name
    <<~CODE
class #{name.camelize}ModelTest < Liza::ModelTest

  test :subject_class do
    assert subject_class == #{name.camelize}Model
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :red
  end

end
    CODE
  end

end
