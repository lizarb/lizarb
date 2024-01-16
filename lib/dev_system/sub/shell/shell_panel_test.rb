class DevSystem::ShellPanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == DevSystem::ShellPanel
  end

  test_methods_defined do
    on_self
    on_instance \
      :convert, :convert!, :convert?, :converter, :converters, :converters_to,
      :format, :format!, :format?, :formatter, :formatters
  end

end
