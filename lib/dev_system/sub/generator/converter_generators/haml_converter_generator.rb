class DevSystem::HamlConverterGenerator < DevSystem::ConverterGenerator

  def self.default_options
    DevBox[:generator].converters[:haml][:options]
  end

  # https://github.com/gjtorikian/commonmarker#usage

  # Haml::Template.options[:ugly] = false
  # Haml::Template.options[:format] = :html5
  # Haml::Template.options[:attr_wrapper] = '"'
  # Haml::Template.options[:escape_html] = true

  def self.convert string, options = {}
    log_details = DevBox[:generator].get :log_details

    log "default_options = #{default_options.inspect} | options = #{options.inspect}" if log_details

    options = default_options.merge options if options.any? && default_options.any?
    
    log "#{string.size} chars (options: #{options.inspect})" if log_details

    haml = string
    # template_options = {escape_html: true}
    template_options = {}
    scope = Object.new
    locals = {}
    require "haml"
    Haml::Template.new(template_options) { haml }.render(scope, locals)
  end

end
