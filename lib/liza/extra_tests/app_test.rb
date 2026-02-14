class Liza::AppTest < Liza::ObjectTest

  test :subject_class do
    assert_equality subject_class, App
  end

  test :cwd, :root do
    # returns a Pathname
    assert_equality App.root.class, Pathname

    # returns the same object each time
    assert_equality App.root.object_id, App.root.object_id

    # the join method creates a new object
    refute_equality App.root.object_id, App.root.join("lib").object_id

    # matches the current working directory
    assert_equality App.root.to_s, Dir.pwd
    Dir.chdir "lib" do
      refute_equality App.root.to_s, Dir.pwd
    end
    assert_equality App.root.to_s, Dir.pwd
  end

  test :directory, :systems_directory, :data_directory, :permanent_directory, :temporary_directory do
    assert_equality App.directory.class,           Pathname
    assert_equality App.systems_directory.class,   Pathname
    assert_equality App.data_directory.class,      Pathname
    assert_equality App.permanent_directory.class, Pathname
    assert_equality App.temporary_directory.class, Pathname
    assert_equality App.directory,                 (App.root / "app")
    assert_equality App.systems_directory,         (App.root / "lib")
    assert_equality App.data_directory,            (App.root / "dat/coding_matrix")
    assert_equality App.permanent_directory,       (App.root / "prm/matrix")
    assert_equality App.temporary_directory,       (App.root / "tmp/coding_matrix")
  end

end
