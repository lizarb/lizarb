class DevSystem::ArrayLogTest < DevSystem::LogTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::ArrayLog, subject_class
    assert_equality DevSystem::ArrayLog, subject.class
  end

  test :call do
    prefix = "  "

    array = [1, 2, 3]
    expected = [
      "Array of size 3",
      "  000 = 1",
      "  001 = 2",
      "  002 = 3"
    ]
    call_subject_with prefix, array, expected

    array = ["1", "2", "3"]
    expected = [
      "Array of size 3",
      '  000 = "1"',
      '  001 = "2"',
      '  002 = "3"'
    ]
    call_subject_with prefix, array, expected

    array = [:a, :b, :c]
    expected = [
      "Array of size 3",
      "  000 = :a",
      "  001 = :b",
      "  002 = :c"
    ]
    call_subject_with prefix, array, expected

    array = [
      (stick :red, "aaaa"),
      " ",
      (stick :green, "bbbb"),
    ]
    expected = "\e[38;2;204;0;0maaaa\e[0m \e[38;2;0;204;0mbbbb\e[0m"
    call_subject_with prefix, array, expected
  end

end
