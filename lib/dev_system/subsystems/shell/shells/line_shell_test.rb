class DevSystem::LineShellTest < DevSystem::ShellTest

  test :subject_class do
    assert_equality subject_class, DevSystem::LineShell
  end

  #

  def get_wall_lines
    lines = render!(:wall, format: :txt).split("\n")
    assert_equality lines.count, 9, kaller: caller
    lines
  end

  group do
    before do
      @lines = get_wall_lines
    end

    #

    test :subject_class, :extract_wall_of do
      expected_lines = render!(:wall_extract_wall_of, format: :txt).split("\n")
  
      new_lines = subject_class.extract_wall_of @lines, "bbb"
      assert_equality new_lines, expected_lines
    end
  
    #
  
    test :subject_class, :replace_wall_of do
      expected_lines = render!(:wall_replace_wall_of, format: :txt).split("\n")
  
      new_lines = subject_class.replace_wall_of @lines, "bbb", ["bbb 123"]
      assert_equality new_lines, expected_lines
    end
  end

  group do
    before do
      @lines = get_wall_lines
    end

    #

    test :subject_class, :extract_between do
      expected_lines = ["bbb 444", "bbb 555", "bbb 666"]
      range = "aaa 333".."ccc 777"

      extracted_lines = subject_class.extract_between(@lines, range)
      assert_equality extracted_lines, expected_lines
    end

    #

    test :subject_class, :replace_between do
      expected_lines = [
        "aaa 111",
        "aaa 222",
        "aaa 333",
        "new line 1",
        "new line 2",
        "ccc 777",
        "ccc 888",
        "ccc 999"
      ]
      range = "aaa 333".."ccc 777"
      new_content = ["new line 1", "new line 2"]

      replaced_lines = subject_class.replace_between(@lines, range, new_content)
      assert_equality replaced_lines, expected_lines
    end
  end

end

__END__

# view wall.txt.erb
aaa 111
aaa 222
aaa 333
bbb 444
bbb 555
bbb 666
ccc 777
ccc 888
ccc 999

# view wall_extract_wall_of.txt.erb
bbb 444
bbb 555
bbb 666

# view wall_replace_wall_of.txt.erb
aaa 111
aaa 222
aaa 333
bbb 123
ccc 777
ccc 888
ccc 999
