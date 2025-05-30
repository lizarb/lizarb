class DevSystem::CoderayGemShellTest < DevSystem::GemShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::CoderayGemShell
    assert_equality subject.class, DevSystem::CoderayGemShell
  end

  test :scan, :loc do
    text = "puts 'Hello, World!'"
    lang = :ruby

    tokens = DevSystem::CoderayGemShell.scan text, lang
    assert_equality tokens.class, CodeRay::TokensProxy

    loc = DevSystem::CoderayGemShell.loc text, lang
    assert_equality loc, 1
  end

end
