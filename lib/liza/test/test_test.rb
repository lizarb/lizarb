module Liza
  class TestTest < Test

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

    group do
      before do
        @a = true
        assert @a
      end

      group do
        before do
          refute @b
          @b = true
        end

        test :Test, :inner do
          assert @a
          assert @b
        end
      end

      test :Test, :outer do
        assert @a
        refute @b
      end

      after do
        assert @a
        refute @b
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
end
