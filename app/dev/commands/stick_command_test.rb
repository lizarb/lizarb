class StickCommandTest < Liza::CommandTest
  
  test :subject_class, :subject do
    assert_equality StickCommand, subject_class
    assert_equality StickCommand, subject.class
  end

  # test :subject_class, :call do
  #   a = 1
  #   b = 2
  #   assert_equality a, b
  # end
  #
  # test :subject, :call do
  #   a = 1
  #   b = 2
  #   assert_equality a, b
  # end
end
