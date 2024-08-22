class StickCommandTest < Liza::SimpleCommandTest
  
  test :subject_class, :subject do
    assert_equality StickCommand, subject_class
    assert_equality StickCommand, subject.class
  end

end
