class DevSystem::ScssConverterGenerator < DevSystem::ConverterGenerator

  def self.default_options
    DevBox[:generator].converters[:scss][:options]
  end

  # https://github.com/gjtorikian/commonmarker#usage

  def self.convert string, options = {}
    log :lower, "default_options = #{default_options.inspect} | options = #{options.inspect}"

    options = default_options.merge options if options.any? && default_options.any?
    
    log :lower, "#{string.size} chars (options: #{options.inspect})"

    require "sassc"
    # output = SassC::Engine.new(scss, line_comments: true).render
    # output = SassC::Engine.new(scss, style: :sass_style_nested).render
    # output = SassC::Engine.new(scss, style: :sass_style_compact).render
    # output = SassC::Engine.new(scss, style: :compressed).render
    # output = SassC::Engine.new(scss).render
    SassC::Engine.new(string, line_comments: true, style: :sass_style_expanded).render
  end

  # def self.sass_to_css sass
  #   scss = sass_to_scss sass
  #   convert scss
  # end

  # def self.sass_to_scss sass
  #   SassC::Sass2Scss.convert(sass)
  # end

  # # https://github.com/sass/sassc-ruby/blob/master/lib/sassc/native/sass_input_style.rb
  # module SassC
  #   module Native
  #     SassInputStyle = enum(
  #       :sass_context_null,
  #       :sass_context_file,
  #       :sass_context_data,
  #       :sass_context_folder
  #     )
  #   end
  # end

  # # https://github.com/sass/sassc-ruby/blob/master/lib/sassc/native/sass_output_style.rb
  # module SassC
  #   module Native
  #     SassOutputStyle = enum(
  #       :sass_style_nested,
  #       :sass_style_expanded,
  #       :sass_style_compact,
  #       :sass_style_compressed
  #     )
  #   end
  # end


end
