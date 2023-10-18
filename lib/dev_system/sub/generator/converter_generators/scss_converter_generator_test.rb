class DevSystem::ScssConverterGeneratorTest < DevSystem::ConverterGeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::ScssConverterGenerator
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  test :convert do
    scss, css = <<-SCSS, <<-CSS
body {
  color: white;
  header {
    color: green;
    nav {
      color: red;
      a {
        color: blue;
        &:hover {
          color: yellow;
        }
      }
    }
  }
}
SCSS
/* line 1, stdin */
body {
  color: white;
}

/* line 3, stdin */
body header {
  color: green;
}

/* line 5, stdin */
body header nav {
  color: red;
}

/* line 7, stdin */
body header nav a {
  color: blue;
}

/* line 9, stdin */
body header nav a:hover {
  color: yellow;
}
CSS

    output = subject_class.convert scss
    assert_equality output, css
  end

end
