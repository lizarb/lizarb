class DevSystem::HamlConverterShellTest < DevSystem::ConverterShellTest

  test :subject_class do
    assert subject_class == DevSystem::HamlConverterShell
  end

  test :convert do
    test_convert <<-HAML, <<-HTML
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
  end

end
