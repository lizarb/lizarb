class QuadraticCommandTest < NarrativeMethodCommandTest

  test :subject_class do
    assert subject_class == QuadraticCommand
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

  test :subject_class, :quadratic do
    assert subject_class.quadratic(1, -11, 30) == [5, 6]
    assert subject_class.quadratic(1, +11, 30) == [-6, -5]
  end

  test :validate, :valid do
    subject = subject_class.new
    subject.instance_variable_set :@args, ["1", "2", "3"]
    subject.validate
    assert subject.instance_variable_get(:@a) == 1
    assert subject.instance_variable_get(:@b) == 2
    assert subject.instance_variable_get(:@c) == 3
  end

  test :validate, :invalid do
    subject = subject_class.new
    subject.instance_variable_set :@args, ["0", "2", "3"]
    begin
      subject.validate
      assert false
    rescue QuadraticCommand::Invalid
      assert true
    else
      assert false
    end
  end

  test :perform do
    subject = subject_class.new
    subject.instance_variable_set :@args, ["1", "-11", "30"]
    subject.validate
    subject.perform
    assert subject.instance_variable_get(:@result) == [5, 6]
  end

end
