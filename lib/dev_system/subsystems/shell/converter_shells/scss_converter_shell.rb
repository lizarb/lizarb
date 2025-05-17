class DevSystem::ScssConverterShell < DevSystem::ConverterShell
  require "sassc"

  # https://github.com/gjtorikian/commonmarker#usage

  def self.call(menv)
    super
    
    string = menv[:convert_in]
    # output = SassC::Engine.new(scss, line_comments: true).render
    # output = SassC::Engine.new(scss, style: :sass_style_nested).render
    # output = SassC::Engine.new(scss, style: :sass_style_compact).render
    # output = SassC::Engine.new(scss, style: :compressed).render
    # output = SassC::Engine.new(scss).render
    output = SassC::Engine.new(string, line_comments: true, style: :sass_style_expanded).render
    menv[:convert_out] = output
  rescue => e
    raise if menv[:raise_errors]
    log stick :light_white, :red, :b, "#{e.class}: #{e.message}"
    menv[:error] = e
    menv[:convert_out] = menv[:convert_in]
  ensure
    nil
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
