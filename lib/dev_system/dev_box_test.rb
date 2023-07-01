class DevSystem::DevBoxTest < Liza::BoxTest

  test :subject_class do
    assert subject_class == DevSystem::DevBox
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

  test :panels do
    assert subject_class[:command].is_a? DevSystem::CommandPanel
    assert subject_class[:log].is_a? DevSystem::LogPanel
  end

end
