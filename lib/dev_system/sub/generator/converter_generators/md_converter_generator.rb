class DevSystem::MdConverterGenerator < DevSystem::ConverterGenerator

  def self.default_options
    DevBox[:generator].converters[:md][:options]
  end

  # https://github.com/gjtorikian/commonmarker#usage

  def self.convert string, options = {}
    log :lower, "default_options = #{default_options.inspect} | options = #{options.inspect}"

    options = default_options.merge options if options.any? && default_options.any?
    
    log :lower, "#{string.size} chars (options: #{options.inspect})"

    require "commonmarker"
    # CommonMarker.render_html markdown, [:HARDBREAKS, :SOURCEPOS, :UNSAFE]
    CommonMarker.render_html string, :DEFAULT
  end

end
