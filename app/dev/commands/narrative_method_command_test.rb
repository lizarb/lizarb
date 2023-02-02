class NarrativeMethodCommandTest < Liza::CommandTest

  test :subject_class do
    assert subject_class == NarrativeMethodCommand
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

  test :validate, :not_implemented do
    subject = subject_class.new
    begin
      subject.validate
      assert false
    rescue NotImplementedError
      assert true
    else
      assert false
    end
  end

  test :perform, :not_implemented do
    subject = subject_class.new
    begin
      subject.perform
      assert false
    rescue NotImplementedError
      assert true
    else
      assert false
    end
  end

end
