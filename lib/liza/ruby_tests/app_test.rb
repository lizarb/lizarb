class Liza::AppTest < Liza::RubyTest
  
  test :subject_class do
    assert_equality subject_class, App
  end

  test :cwd, :root do
    # returns a Pathname
    assert App.root.is_a?(Pathname)

    # returns a new object each time
    refute_equality App.cwd.object_id, App.cwd.object_id
    
    # returns the same object each time
    assert_equality App.root.object_id, App.root.object_id

    # the join method creates a new object
    refute_equality App.root.object_id, App.root.join("lib").object_id

    # matches the current working directory
    assert_equality App.root, App.cwd
    Dir.chdir "lib" do
      refute_equality App.root, App.cwd
    end
    assert_equality App.root, App.cwd
  end
  
end
