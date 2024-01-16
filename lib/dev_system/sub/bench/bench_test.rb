class DevSystem::BenchTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == DevSystem::Bench
  end

  test_methods_defined do
    on_self
    on_instance
  end

  test :settings do
    assert_equality subject_class.token, nil
    assert_equality subject_class.singular, :bench
    assert_equality subject_class.plural, :benches

    assert_equality subject_class.system, DevSystem
    assert_equality subject_class.subsystem, DevSystem::Bench
    assert_equality subject_class.division, DevSystem::Bench
  end

end
