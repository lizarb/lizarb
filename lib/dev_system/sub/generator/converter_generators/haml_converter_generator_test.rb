class DevSystem::HamlConverterGeneratorTest < DevSystem::ConverterGeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::HamlConverterGenerator
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  test :convert do
    haml, html = <<-HAML, <<-HTML
%body
  %header
    %nav
      %a
        %span
HAML
<body>
<header>
<nav>
<a>
<span></span>
</a>
</nav>
</header>
</body>
HTML

    output = subject_class.convert haml
    assert_equality output, html
  end

end
