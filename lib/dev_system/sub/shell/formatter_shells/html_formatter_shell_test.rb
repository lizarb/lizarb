class DevSystem::HtmlFormatterShellTest < DevSystem::FormatterShellTest

  test :subject_class do
    assert subject_class == DevSystem::HtmlFormatterShell
  end

  test :format do
    test_format <<-HTML_1, <<-HTML_2
<!DOCTYPE html>
<html>
<head>
<title>Beauty</title>
</head>
<body>
<header>
<nav>
<a>
<span></span>
</a>
</nav>
</header>
</body>
</html>
HTML_1
<!DOCTYPE html>
<html>
  <head>
    <title>Beauty</title>
  </head>
  <body>
    <header>
      <nav>
        <a>
          <span></span>
        </a>
      </nav>
    </header>
  </body>
</html>
HTML_2
  end

end
