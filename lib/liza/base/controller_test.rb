module Liza
  class ControllerTest < UnitTest
    test :subject_class do
      assert subject_class == Liza::Controller
    end

    test :settings do
      assert subject_class.log_level == :normal
      assert subject_class.log_color == :white
    end
  end
end
