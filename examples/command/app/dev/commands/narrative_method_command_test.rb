class NarrativeMethodCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert subject_class == NarrativeMethodCommand
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
