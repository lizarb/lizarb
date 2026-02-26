class GraphSystem::DigestSha1GemShellTest < DevSystem::GemShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, GraphSystem::DigestSha1GemShell
    assert_equality subject.class, GraphSystem::DigestSha1GemShell
  end

  def digest_hex(s)
    menv = {digest_hex_in: s}
    subject_class.digest_hex(menv)
    menv[:digest_hex_out]
  end

  test :digest_hex do
    assert_equality digest_hex("hello"), "aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d"
    assert_equality digest_hex(""),      "da39a3ee5e6b4b0d3255bfef95601890afd80709"
    assert_equality digest_hex(nil),     "da39a3ee5e6b4b0d3255bfef95601890afd80709"
    assert_equality digest_hex("0"),     "b6589fc6ab0dc82cf12099d1c2d40ab994e8410c"
    assert_equality digest_hex(0),       "b6589fc6ab0dc82cf12099d1c2d40ab994e8410c"
    assert_equality digest_hex(0.0),     "38f6d7875e3195bdaee448d2cb6917f3ae4994af"
  end

end
