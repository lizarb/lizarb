class DevSystem::MdConverterShell < DevSystem::ConverterShell
  require "commonmarker"

  def self.default_options
    DevBox[:shell].converters[:md][:options]
  end

  # https://github.com/gjtorikian/commonmarker#usage

  def self.convert string, options = {}
    log :higher, "default_options = #{default_options.inspect} | options = #{options.inspect}"

    options = default_options.merge options if options.any? && default_options.any?
    
    log :higher, "#{string.size} chars (options: #{options.inspect})"

    call({})
    # CommonMarker.render_html markdown, [:HARDBREAKS, :SOURCEPOS, :UNSAFE]
    CommonMarker.render_html string, :DEFAULT
  end

end
