class ExampleCommandTest < AppCommandTest

  test :subject_class do
    assert subject_class == ExampleCommand
  end

  group "class methods" do

    test :class_helper_method_1 do
      assert subject_class.class_helper_method_1([]) == 1
    end

    test :class_helper_method_2 do
      assert subject_class.class_helper_method_2([]) == 2
    end

    test :class_helper_method_3 do
      assert subject_class.class_helper_method_3([]) == 3
    end

  end

  group "instance methods" do

    before do
      @subject = subject_class.new([1, 2, 3])
    end

    test :helper_method_1 do
      assert @subject.helper_method_1([]) == 1
    end

    test :helper_method_2 do
      assert @subject.helper_method_2([]) == 2
    end

    test :helper_method_3 do
      assert @subject.helper_method_3([]) == 3
    end

  end

end
