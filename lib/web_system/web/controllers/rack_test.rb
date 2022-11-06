class WebSystem
  class RackTest < Liza::ControllerTest

    test :subject_class do
      assert subject_class == WebSystem::Rack
    end

    test :settings do
      assert subject_class.log_level == :normal
      assert subject_class.log_color == :blue
    end

    # test :call do
    #   todo "write this"
    # end

  end
end
