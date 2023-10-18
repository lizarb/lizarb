class DevSystem::FileShellTest < DevSystem::ShellTest

  # before do
  #   puts tmp.to_s.magenta
  # end

  def tmp_dir
    @tmp_dir ||= begin
      name = self.class.name.split("::").map(&:snakefy).join "_"
      time = Time.now.strftime "%Y%m%d_%H%M%S"
      random = SecureRandom.hex 4
      ret = Pathname.new(Dir.pwd).join "tmp/test_#{App.mode}_#{name}_#{time}_#{random}"
      FileUtils.mkdir_p ret
      log "Created tmp_dir: #{ret}"
      ret
    end
  end

  after do
    # NOTE: @tmp_dir does not create a new directory for each test
    if @tmp_dir
      FileUtils.rm_rf @tmp_dir
      log "Removed tmp_dir: #{@tmp_dir}"
    end
  end

  #

  test :subject_class do
    assert subject_class == DevSystem::FileShell
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  #

  test :subject_class, :exist?, :true do
    assert subject_class.exist? __FILE__
  end

  test :subject_class, :exist?, :false do
    refute subject_class.exist? "does_not_exist_#{rand 999}"
  end

  test :subject_class, :exist?, :raise do
    assert_raises ArgumentError do
      subject_class.exist? nil
    end

    assert_raises ArgumentError do
      subject_class.exist? ""
    end
  end

  #

  test :subject_class, :size, true do
    assert subject_class.size(__FILE__).positive?
  end

  test :subject_class, :size, :raise do
    assert_raises ArgumentError do
      subject_class.size nil
    end

    assert_raises ArgumentError do
      subject_class.size ""
    end

    assert_raises ArgumentError do
      subject_class.size "does_not_exist_#{rand 999}"
    end
  end

  #

  test :subject_class, :directory?, true do
    assert subject_class.directory? Dir.pwd
  end

  test :subject_class, :directory?, false do
    refute subject_class.directory? __FILE__
    refute subject_class.directory? "does_not_exist"
  end

  test :subject_class, :directory?, :raise do
    assert_raises ArgumentError do
      subject_class.directory? nil
    end

    assert_raises ArgumentError do
      subject_class.directory? ""
    end
  end

  test :subject_class, :file?, true do
    assert subject_class.file? __FILE__
  end

  test :subject_class, :file?, false do
    refute subject_class.file? Dir.pwd
    refute subject_class.file? "does_not_exist_#{rand 999}"
  end

  test :subject_class, :file?, :raise do
    assert_raises ArgumentError do
      subject_class.file? nil
    end

    assert_raises ArgumentError do
      subject_class.file? ""
    end
  end

  #

  test :subject_class, :touch, true do
    path = tmp_dir.join "touch_#{Time.now.to_i}"
    refute subject_class.exist? path

    assert subject_class.touch path
    assert subject_class.exist? path
  end

  test :subject_class, :touch, :raise do
    assert_raises ArgumentError do
      subject_class.touch nil
    end

    assert_raises ArgumentError do
      subject_class.touch ""
    end
  end

  #

  test :subject_class, :gitkeep do
    path = tmp_dir.join "gitkeep_#{Time.now.to_i}"
    refute subject_class.exist? path

    assert subject_class.gitkeep path
    assert subject_class.exist? path
  end

  #

end
