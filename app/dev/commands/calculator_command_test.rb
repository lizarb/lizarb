class CalculatorCommandTest < NarrativeMethodCommandTest

  test :subject_class do
    assert subject_class == CalculatorCommand
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

  test :subject_class, :sum do
    assert subject_class.sum(1, 2) == 3
  end

  test :subject_class, :sub do
    assert subject_class.sub(1, 2) == -1
  end

  test :subject_class, :mul do
    assert subject_class.mul(1, 2) == 2
  end

  test :subject_class, :div do
    assert subject_class.div(10, 2) == 5
  end

  test :validate, :valid do
    subject = subject_class.new
    subject.instance_variable_set :@args, ["1", "+", "2"]
    subject.validate
    assert subject.instance_variable_get(:@a) == 1
    assert subject.instance_variable_get(:@op) == :+
    assert subject.instance_variable_get(:@b) == 2
  end

  test :validate, :invalid do
    subject = subject_class.new
    subject.instance_variable_set :@args, ["1", "x", "2"]
    begin
      subject.validate
      assert false
    rescue CalculatorCommand::Invalid
      assert true
    else
      assert false
    end
  end

  test :perform do
    subject = subject_class.new
    subject.instance_variable_set :@args, ["1", "+", "2"]
    subject.validate
    subject.perform
    assert subject.instance_variable_get(:@result) == 3
  end

end
