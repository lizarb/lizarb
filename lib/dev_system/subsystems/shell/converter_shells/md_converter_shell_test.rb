class DevSystem::MdConverterShellTest < DevSystem::ConverterShellTest

  test :subject_class do
    assert subject_class == DevSystem::MdConverterShell
  end

  test :convert do
    test_convert <<-MARKDOWN, <<-HTML
# Hello World

## Hello World

### Hello World

#### Hello World

##### Hello World

###### Hello World

MARKDOWN
<h1><a href="#hello-world" aria-hidden="true" class="anchor" id="hello-world"></a>Hello World</h1>
<h2><a href="#hello-world-1" aria-hidden="true" class="anchor" id="hello-world-1"></a>Hello World</h2>
<h3><a href="#hello-world-2" aria-hidden="true" class="anchor" id="hello-world-2"></a>Hello World</h3>
<h4><a href="#hello-world-3" aria-hidden="true" class="anchor" id="hello-world-3"></a>Hello World</h4>
<h5><a href="#hello-world-4" aria-hidden="true" class="anchor" id="hello-world-4"></a>Hello World</h5>
<h6><a href="#hello-world-5" aria-hidden="true" class="anchor" id="hello-world-5"></a>Hello World</h6>
HTML
  end

end
