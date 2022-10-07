class DevSystem
  class CommandPanelTest < Liza::PanelTest

    test :subject_class do
      assert subject_class == DevSystem::CommandPanel
    end

    test :settings do
      assert subject_class.log_level == :normal
      assert subject_class.log_color == :green
    end

    test :call do
      begin
        subject.call ["echo", 1, 2, 3]
        assert false
      rescue RuntimeError => e
        assert e.message == "[1, 2, 3]"
      end
    end

  end
end
