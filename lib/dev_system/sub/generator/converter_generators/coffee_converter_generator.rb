class DevSystem::CoffeeConverterGenerator < DevSystem::ConverterGenerator

  def self.default_options
    DevBox[:generator].converters[:coffee][:options]
  end

  # https://github.com/rails/ruby-coffee-script

  def self.convert string, options = {}
    log :lower, "default_options = #{default_options.inspect} | options = #{options.inspect}"

    options = default_options.merge options if options.any? && default_options.any?
    
    log :lower, "#{string.size} chars (options: #{options.inspect})"

    require "coffee-script"
    
    CoffeeScript.compile string
  end

end
