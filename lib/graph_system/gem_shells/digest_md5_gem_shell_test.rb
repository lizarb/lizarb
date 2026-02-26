class GraphSystem::DigestMd5GemShellTest < DevSystem::GemShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, GraphSystem::DigestMd5GemShell
    assert_equality subject.class, GraphSystem::DigestMd5GemShell
  end

  def digest_hex(s)
    menv = {digest_hex_in: s}
    subject_class.digest_hex(menv)
    menv[:digest_hex_out]
  end

  test :digest_hex do
    assert_equality digest_hex("hello"), "5d41402abc4b2a76b9719d911017c592"
    assert_equality digest_hex(""),      "d41d8cd98f00b204e9800998ecf8427e"
    assert_equality digest_hex(nil),     "d41d8cd98f00b204e9800998ecf8427e"
    assert_equality digest_hex("0"),     "cfcd208495d565ef66e7dff9f98764da"
    assert_equality digest_hex(0),       "cfcd208495d565ef66e7dff9f98764da"
    assert_equality digest_hex(0.0),     "30565a8911a6bb487e3745c0ea3c8224"
  end

end
