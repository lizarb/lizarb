class NetSystem::RecordGenerator < DevSystem::Generator
  main_dsl

  FOLDER = "app/net/records"

  generate :controller do
    folder FOLDER
    filename "#{name}_record.rb"
    content record_content name
  end

  generate :controller_test do
    folder FOLDER
    filename "#{name}_record_test.rb"
    content record_test_content name
  end

  # helper methods

  def record_content name
    <<~CODE
class #{name.camelize}Record < AppRecord
  set :table, :#{name}s

end
    CODE
  end

  def record_test_content name
    <<~CODE
class #{name.camelize}RecordTest < Liza::RecordTest

  test :subject_class do
    assert subject_class == #{name.camelize}Record
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
    CODE
  end

end
