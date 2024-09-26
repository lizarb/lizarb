class DevSystem::HashLogTest < DevSystem::LogTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::HashLog, subject_class
    assert_equality DevSystem::HashLog, subject.class
  end

  test :call do
    prefix = "  "
    hash = { a: 1, b: 2, c: 3 }
    expected = [
      "Hash of size 3",
      "  a = 1",
      "  b = 2",
      "  c = 3"
    ]
    call_subject_with prefix, hash, expected

    hash = { a: "1", b: "2", c: "3" }
    expected = [
      "Hash of size 3",
      '  a = "1"',
      '  b = "2"',
      '  c = "3"'
    ]
    call_subject_with prefix, hash, expected

    hash = { a: :a, b: :b, c: :c }
    expected = [
      "Hash of size 3",
      "  a = :a",
      "  b = :b",
      "  c = :c"
    ]
    call_subject_with prefix, hash, expected
  end
  
end
