class Liza::ClassTest < Liza::ObjectTest
  
  test :subject_class do
    assert_equality subject_class, Class
  end

  test :ancestors_until do
    assert_equality [Object],  Object.ancestors_until(BasicObject)
    assert_equality [Integer], Integer.ancestors_until(Object)
    assert_equality [Symbol],  Symbol.ancestors_until(Object)
    assert_equality [String],  String.ancestors_until(Object)
    assert_equality [Array],   Array.ancestors_until(Object)
    assert_equality [Hash],    Hash.ancestors_until(Object)

    assert_equality [IrbCommand, Command],  IrbCommand.ancestors_until(Command)
    assert_equality [PryCommand, Command],  PryCommand.ancestors_until(Command)
    assert_equality [TestCommand, Command], TestCommand.ancestors_until(Command)
  end

end
