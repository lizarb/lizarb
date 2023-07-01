class DevSystem::TextShellTest < DevSystem::FileShellTest

  test :subject_class do
    assert subject_class == DevSystem::TextShell
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

  #

  test :subject_class, :read, true do
    assert subject_class.read(__FILE__).size.positive?
  end

  test :subject_class, :read, :raise do
    assert_raises ArgumentError do
      subject_class.read nil
    end

    assert_raises ArgumentError do
      subject_class.read ""
    end

    assert_raises ArgumentError do
      subject_class.read "does_not_exist_#{rand 999}"
    end
  end

  #

  test :subject_class, :write, :raise do
    assert_raises ArgumentError do
      subject_class.write nil, "content"
    end

    assert_raises ArgumentError do
      subject_class.write "", "content"
    end
  end

  test :subject_class, :write, true do
    path = tmp_dir.join "write_#{Time.now.to_i}"
    
    refute subject_class.exist? path
    assert subject_class.write path, "content"
    
    assert subject_class.exist? path
    assert subject_class.read(path) == "content"
  end

  test :subject_class, :write, :encoding do
    path = tmp_dir.join "write_#{Time.now.to_i}"
    s1 = "content"

    refute subject_class.exist? path
    assert subject_class.write path, s1

    s2 = subject_class.read path
    assert_equality s1, s2
    assert_equality s1.encoding, s2.encoding

    assert_equality s1.encoding, Encoding::UTF_8
    assert_equality s2.encoding, Encoding::UTF_8
  end

  test :subject_class, :write, :create_dir do
    path = tmp_dir.join "write_dir_#{Time.now.to_i}/a/b/c"
    
    refute subject_class.exist? path

    assert_raises Errno::ENOENT do
      assert subject_class.write path, "content", create_dir: false
    end

    assert subject_class.write path, "content", create_dir: true

    assert subject_class.exist? path
    assert subject_class.read(path) == "content"
  end

end
