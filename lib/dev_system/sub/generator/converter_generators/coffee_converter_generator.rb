class DevSystem::CoffeeConverterGenerator < DevSystem::ConverterGenerator

  def self.default_options
    DevBox[:generator].converters[:coffee][:options]
  end

  # https://github.com/rails/ruby-coffee-script

  def self.convert string, options = {}
    log_details = DevBox[:generator].get :log_details

    log "default_options = #{default_options.inspect} | options = #{options.inspect}" if log_details

    options = default_options.merge options if options.any? && default_options.any?
    
    log "#{string.size} chars (options: #{options.inspect})" if log_details

    CoffeeScript.compile string
  end

end
