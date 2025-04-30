class DevSystem::ShellPanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == DevSystem::ShellPanel
  end

  test_methods_defined do
    on_self
    on_instance \
      :convert, :convert?, :converter, :converters, :converters_to,
      :format, :format?, :formatter, :formatters
  end

  test :converters do
    assert_equality subject.converters, {}
    assert_equality subject.converters_to, {}
    assert_equality subject.formatters, {}


    subject.converter :html, :md
    assert_equality subject.converters, { md: { to: :html, from: :md, options: {} } }
    assert_equality subject.converters_to, { html: [{ to: :html, from: :md, options: {} }] }
    
    refute subject.convert? :html, :html
    assert subject.convert? :md,   :html
    refute subject.convert? :haml, :html
    
    subject.converter :html, :haml
    assert_equality subject.converters, { md: { to: :html, from: :md, options: {} }, haml: { to: :html, from: :haml, options: {} } }
    assert_equality subject.converters_to, { html: [{ to: :html, from: :md, options: {} }, { to: :html, from: :haml, options: {} }] }

    refute subject.convert? :html, :html
    assert subject.convert? :md,   :html
    assert subject.convert? :haml, :html
  end

end
