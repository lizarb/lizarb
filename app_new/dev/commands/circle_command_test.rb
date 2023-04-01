class CircleCommandTest < NarrativeMethodCommandTest

  test :subject_class do
    assert subject_class == CircleCommand
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

  test :subject_class, :area do
    assert subject_class.area(1) == 3.141592653589793
  end

  test :subject_class, :circumference do
    assert subject_class.circumference(1) == 6.283185307179586
  end

  test :validate, :valid, :area do
    subject = subject_class.new
    subject.instance_variable_set :@args, ["area", "1"]
    subject.validate
    assert subject.instance_variable_get(:@radius) == 1
  end

  test :validate, :invalid, :area do
    subject = subject_class.new
    subject.instance_variable_set :@args, ["area", "0"]
    begin
      subject.validate
      assert false
    rescue CircleCommand::Invalid
      assert true
    else
      assert false
    end
  end

  test :validate, :valid, :circumference do
    subject = subject_class.new
    subject.instance_variable_set :@args, ["circumference", "1"]
    subject.validate
    assert subject.instance_variable_get(:@radius) == 1
  end

  test :validate, :invalid, :circumference do
    subject = subject_class.new
    subject.instance_variable_set :@args, ["circumference", "0"]
    begin
      subject.validate
      assert false
    rescue CircleCommand::Invalid
      assert true
    else
      assert false
    end
  end

  test :perform, :area do
    subject = subject_class.new
    subject.instance_variable_set :@args, ["area", "1"]
    subject.validate
    subject.perform
    assert subject.instance_variable_get(:@result) == 3.141592653589793
  end

  test :perform, :circumference do
    subject = subject_class.new
    subject.instance_variable_set :@args, ["circumference", "1"]
    subject.validate
    subject.perform
    assert subject.instance_variable_get(:@result) == 6.283185307179586
  end

end
