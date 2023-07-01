class DevSystem::DirShellTest < DevSystem::FileShellTest

  test :subject_class do
    assert subject_class == DevSystem::DirShell
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

  #

  test :subject_class, :exist?, :raise do
    assert_raises ArgumentError do
      subject_class.exist? nil
    end

    assert_raises ArgumentError do
      subject_class.exist? ""
    end
  end

  test :subject_class, :exist?, true do
    assert subject_class.exist? Dir.pwd
  end

  test :subject_class, :exist?, false do
    refute subject_class.exist? "does_not_exist"
  end

  test :subject_class, :size, :raise do
    assert_raises ArgumentError do
      subject_class.size nil
    end

    assert_raises ArgumentError do
      subject_class.size ""
    end

    assert_raises ArgumentError do
      subject_class.size "does_not_exist"
    end
  end

  test :subject_class, :size, true do
    assert subject_class.size(Dir.pwd).positive?
  end

  #

  test :subject_class, :create, :raise do
    assert_raises ArgumentError do
      subject_class.create nil
    end

    assert_raises ArgumentError do
      subject_class.create ""
    end
  end

  test :subject_class, :create, true do
    path = tmp_dir.join "create_#{Time.now.to_i}"
    refute subject_class.exist? path

    subject_class.create path
    assert subject_class.exist? path
  end

end
