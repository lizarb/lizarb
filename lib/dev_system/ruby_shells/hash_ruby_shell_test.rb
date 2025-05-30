class DevSystem::HashRubyShellTest < DevSystem::RubyShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::HashRubyShell
    assert_equality subject.class, DevSystem::HashRubyShell
  end

  section :mergers

  test :reverse_merge do
    hash = { a: 1, b: "new_value"}
    other = { b: "default value", c: 3 }
    expected = { a: 1, b: "new_value", c: 3 }
    actual = subject_class.reverse_merge(hash, other)
    assert_equality expected, actual
  end

  test :reverse_merge! do
    hash = { a: 1, b: "new_value"}
    other = { b: "default value", c: 3 }
    expected = { a: 1, b: "new_value", c: 3 }
    subject_class.reverse_merge!(hash, other)
    assert_equality expected, hash
  end

  section :transformers

  test :symbolize_keys do
    hash = { "a" => 1, "b" => 2 }
    expected = { a: 1, b: 2 }
    actual = subject_class.symbolize_keys(hash)
    assert_equality expected, actual
  end

  test :symbolize_keys! do
    hash = { "a" => 1, "b" => 2 }
    expected = { a: 1, b: 2 }
    subject_class.symbolize_keys!(hash)
    assert_equality expected, hash
  end

  test :symbolize_keys_recursive do
    hash = { "a" => 1, "b" => { "c" => 2, "d" => 3 } }
    expected = { a: 1, b: { c: 2, d: 3 } }
    actual = subject_class.symbolize_keys_recursive(hash)
    assert_equality expected, actual
  end

  test :symbolize_keys_recursive! do
    hash = { "a" => 1, "b" => { "c" => 2, "d" => 3 } }
    expected = { a: 1, b: { c: 2, d: 3 } }
    subject_class.symbolize_keys_recursive!(hash)
    assert_equality expected, hash
  end

  section :stringify

  test :stringify_keys do
    hash = { a: 1, b: 2 }
    expected = { "a" => 1, "b" => 2 }
    actual = subject_class.stringify_keys(hash)
    assert_equality expected, actual
  end

  test :stringify_keys! do
    hash = { a: 1, b: 2 }
    expected = { "a" => 1, "b" => 2 }
    subject_class.stringify_keys!(hash)
    assert_equality expected, hash
  end

  test :stringify_keys_recursive do
    hash = { a: 1, b: { c: 2, d: 3 } }
    expected = { "a" => 1, "b" => { "c" => 2, "d" => 3 } }
    actual = subject_class.stringify_keys_recursive(hash)
    assert_equality expected, actual
  end

  test :stringify_keys_recursive! do
    hash = { a: 1, b: { c: 2, d: 3 } }
    expected = { "a" => 1, "b" => { "c" => 2, "d" => 3 } }
    subject_class.stringify_keys_recursive!(hash)
    assert_equality expected, hash
  end

end
