module Liza
  class BoxTest < UnitTest
    test :subject_class do
      assert subject_class == Liza::Box
    end

    test :settings do
      assert subject_class.log_level == :normal
      assert subject_class.log_color == :white
    end
  end
end
