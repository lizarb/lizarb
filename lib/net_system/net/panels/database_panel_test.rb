class NetSystem
  class DatabasePanelTest < Liza::PanelTest

    test :subject_class do
      assert subject_class == NetSystem::DatabasePanel
    end

    test :settings do
      assert subject_class.log_level == :normal
      assert subject_class.log_color == :red
    end

    # test :call do
    #   todo "write this"
    # end

  end
end
