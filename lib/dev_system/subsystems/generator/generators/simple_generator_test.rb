class DevSystem::SimpleGeneratorTest < DevSystem::BaseGeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::SimpleGenerator
  end

  test_erbs_defined(
    "subject.rb.erb",
    "unit.rb.erb"
  )

  # helper methods

  def call_with(name, action, placement, superklass, path)
    menv = {}
    menv[:name] = name.to_s
    menv[:generator_action] = action.to_s
    menv[:placement] = placement
    menv[:superclass] = superklass
    menv[:path] = path

    subject.call menv
  end

  def assert_change_count count, kaller: nil
    kaller ||= caller
    assert_equality subject.changes.count, count, kaller: kaller
  end

  def assert_change index, path, lines_count, first_line, kaller: nil
    kaller ||= caller
    unless assert subject.changes[index].path.to_s.end_with?(path), kaller: kaller
      puts stick :red, "#{subject.changes[index].path.inspect} does not end with #{path.inspect}"
    end
    assert_equality subject.changes[index].new_lines.count, lines_count, kaller: kaller
    assert_equality subject.changes[index].new_lines[0].strip, first_line, kaller: kaller
  end

end
