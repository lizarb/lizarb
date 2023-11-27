
class Liza::TestTest < Liza::UnitTest

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  test_methods_defined do
    on_self \
      :after, :after_stack,
      :before, :before_stack,
      :call,
      :division,
      :group,
      :log_test_building, :log_test_building?,
      :subject_class,
      :test, :test_node, :test_tree,
      :totals
    on_instance \
      :assert, :assert!,
      :assert_equality, :assert_equality!,
      :assert_raises, :assert_raises!,
      :assertions, :assertions=,
      :call,
      :critical,
      :division,
      :group,
      :log_test_assertion, :log_test_assertion?,
      :log_test_assertion_message, :log_test_assertion_message?,
      :log_test_assertion_result, :log_test_building?,
      :log_test_call, :log_test_call_block?, :log_test_call_rescue,
      :refute, :refute!,
      :refute_equality, :refute_equality!,
      :refute_raises, :refute_raises!,
      :subject, :subject_class,
      :test_words,
      :todo
  end

  group :basics do
    test :truths do
      assert true
      assert true
      assert true
    end

    test :falsehoods do
      refute false
      refute false
      refute false
    end

    test :assertions do
      assert assertions == 0
      refute assertions != 1
      assert assertions == 2
    end
  end

  group :assertions do
    test :assert do
      assert 0
      assert 1
      assert :a
      assert "a"
      assert ""
      assert []
      assert [1]
      assert({})
      assert({a: 1})
      assert true
      refute false
      refute nil
    end

    test :assert_equality do
      assert_equality 0, 0
      assert_equality 1, 1
      assert_equality :a, :a
      assert_equality "a", "a"
      assert_equality "", ""
      assert_equality [], []
      assert_equality [1], [1]
      assert_equality({}, {})
      assert_equality({a: 1}, {a: 1})
      assert_equality true, true
      refute_equality false, true
      refute_equality nil, true
    end
    
    test :assert_raises do
      assert_raises StandardError do
        raise RuntimeError
      end

      assert_raises RuntimeError do
        raise RuntimeError
      end

      refute_raises RuntimeError do
        raise StandardError
      end
    end
  end
  
  group :instance_variables do
    test :instance_variables do
      if Shell.jruby?
        todo "jruby!"
      else
        assert_equality instance_variables, [:@test_words, :@before_stack, :@after_stack, :@test_block, :@settings]
      end
    end

    test :test_block do
      assert_equality @test_block.source_location[1], __LINE__ - 1
    end
  end

  group :tree do
    test :test_tree do
      assert_equality self.class.test_tree.class, Liza::TestTreePart
      assert_equality self.class.test_tree, self.class.test_tree.parent
      
      assert_equality 4, self.class.test_tree.tests.count
      assert_equality 5, self.class.test_tree.children.count

      a = self.class.test_tree.tests.map(&:first).flatten
      b = [:settings, :subject_class, :methods_defined, :subject_class, :instance_methods_defined, :instance_groups]
      assert_equality a, b
    end
  end

  test :instance_groups do
    assert assertions == 0

    group do
      assert true
      assert true
      assert true
    end

    assert assertions == 2

    group do
      assert true
      group do
        assert true
      end
      assert true
    end

    assert assertions == 4
  end

  group :class_groups do
    before do
      @string = "START"
      assert_equality @string, "START"
    end

    test :class_groups, :outer_a do
      @string.concat "-123"
      assert_equality @string, "START-123"
      #
      @expectation_outer = "START-123-FINISH"
    end

    test :class_groups, :outer_b do
      @string.concat "-321"
      assert_equality @string, "START-321"
      #
      @expectation_outer = "START-321-FINISH"
    end

    group :class_groups_inner do
      before do
        @string.concat "-BEGIN"
        assert_equality @string, "START-BEGIN"
      end

      test :class_groups, :inner_a do
        @string.concat "-aaa"
        assert_equality @string, "START-BEGIN-aaa"
        #
        @expectation_inner = "START-BEGIN-aaa-END"
        @expectation_outer = "START-BEGIN-aaa-END-FINISH"
      end

      test :class_groups, :inner_b do
        @string.concat "-bbb"
        assert_equality @string, "START-BEGIN-bbb"
        #
        @expectation_inner = "START-BEGIN-bbb-END"
        @expectation_outer = "START-BEGIN-bbb-END-FINISH"
      end

      after do
        @string.concat "-END"
        assert_equality @string, @expectation_inner
      end
    end

    after do
      @string << "-FINISH"
      assert_equality @string, @expectation_outer
    end
  end

  # group :throwables do
  #   test :throw_within_test do
  #     assert! true
  #     assert! false
  #     raise "it should not have reached this line"
  #   end

  #   group :throw_within_before do
  #     before do
  #       assert! false
  #     end

  #     test :that_will_not_run do
  #       raise "it should not have reached this line"
  #     end
  #   end

  #   group :throw_within_after do
  #     test :that_will_not_run do
  #       assert! false
  #     end

  #     after do
  #       raise "it should not have reached this line"
  #     end
  #   end
  # end
end
