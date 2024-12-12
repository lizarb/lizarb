class DevSystem::HamlConverterShell < DevSystem::ConverterShell
  require "haml"

  # https://github.com/gjtorikian/commonmarker#usage

  # Haml::Template.options[:ugly] = false
  # Haml::Template.options[:format] = :html5
  # Haml::Template.options[:attr_wrapper] = '"'
  # Haml::Template.options[:escape_html] = true

  def self.call(env)
    super

    haml = env[:convert_in]
    # template_options = {escape_html: true}
    template_options = {}
    scope = Object.new
    locals = {}
    env[:convert_out] = Haml::Template.new(template_options) { haml }.render(scope, locals)
  rescue => e
    raise if env[:raise_errors]
    log stick :light_white, :red, :b, "#{e.class}: #{e.message}"
    env[:error] = e
    env[:convert_out] = env[:convert_in]
  ensure
    nil
  end

end
