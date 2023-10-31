class DevSystem::MdConverterShellTest < DevSystem::ConverterShellTest

  test :subject_class do
    assert subject_class == DevSystem::MdConverterShell
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  test :convert do
    markdown, html = <<-MARKDOWN, <<-HTML
# Hello World

## Hello World

### Hello World

#### Hello World

##### Hello World

###### Hello World

MARKDOWN
<h1>Hello World</h1>
<h2>Hello World</h2>
<h3>Hello World</h3>
<h4>Hello World</h4>
<h5>Hello World</h5>
<h6>Hello World</h6>
HTML

    output = subject_class.convert markdown
    assert_equality output, html
  end

end
