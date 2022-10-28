class DevSystem
  class FileShellTest < ShellTest

    test :subject_class do
      assert subject_class == DevSystem::FileShell
    end

    test :settings do
      assert subject_class.log_level == :normal
      assert subject_class.log_color == :green
    end

  end
end
