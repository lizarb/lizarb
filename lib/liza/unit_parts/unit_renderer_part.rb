class Liza::UnitRendererPart < Liza::Part

  RENDER_STACK_IS_EMPTY_MESSAGE = <<~STRING
You called render without ERB keys,
but the render stack is empty.
Did you forget to add ERB keys?
  STRING

  RENDER_STACK_IS_FULL_MESSAGE = <<~STRING
You called render with too many ERB keys.
Did you accidentally fall into an infinite loop?
  STRING

  insertion do
    def render! *keys, format: nil
      render *keys, format: format, allow_missing: false
    end

    def render *keys, format: nil, allow_missing: true
      format = @render_format ||= @format if format.nil?
      raise "@render_format or @format must be set, or format keyword-argument must be given" if format.nil?
      @render_format = format = format.to_sym

      log_rendering = log_level? :high
      
      if keys.any?
        log_render_in keys, kaller: caller if log_rendering

        erbs = self.class.erbs_for format, keys, allow_missing: allow_missing
        erbs.to_a.reverse.each do |key, erb|
          if true
            t = Time.now
            s = erb.result binding, self
            log_render_out "#{erb.name}.#{erb.format}", s.length, t.diff, kaller: caller if log_rendering
          end
          
          if DevBox.convert? erb.format
            t = Time.now
            s = DevBox.convert erb.format, s
            log_render_convert "#{erb.name}.#{format}", s.length, t.diff, kaller: caller if log_rendering
          end
  
          render_stack.push s

          raise RenderStackIsFull RENDER_STACK_IS_FULL_MESSAGE, caller if render_stack.size > 10
        end
  
        render_stack.pop
      elsif render_stack.any?
        render_stack.pop
      else
        raise RenderStackIsEmpty, RENDER_STACK_IS_EMPTY_MESSAGE, caller
      end
    end

    def render_stack
      @render_stack ||= []
    end

    def log_render_in keys, kaller: 
      if render_stack.any?
        log "render → #{keys.join " "}", kaller: kaller
      else
        log "render #{"→ " * keys.size}#{keys.join " "}", kaller: kaller
      end
    end

    def log_render_out key, length, t, kaller: 
      if render_stack.any?
        log "render #{"← #{key}".ljust_blanks 25} #{length.to_s.rjust_blanks 4} characters in #{t}s", kaller: kaller
      else
        log "render #{"← #{key}".ljust_blanks 25} #{length.to_s.rjust_blanks 4} characters in #{t}s", kaller: kaller
      end
    end

    def log_render_convert key, length, t, kaller: 
      log "convert  #{"#{key}".ljust_blanks 23} #{length.to_s.rjust_blanks 4} characters in #{t}s", kaller: kaller
    end

    # class level methods

    def self.erbs_defined
      @erbs_defined ||= LERB.load(self.source_location_radical)
    end

    def self.erbs_available ref = Liza::Unit
      @erbs_available ||= begin
        h = {}

        ancestors.take_while do |ancestor|
          ancestor != ref
        end.reverse.each do |ancestor|
          ancestor.erbs_defined.each do |erb|
            h[erb.key] = erb
          end
        end

        h.values
      end
    end

    def self.renderable_names
      erbs_available.map(&:name).uniq
    end

    def self.renderable_formats_for name_string
      erbs_available.select { _1.name == name_string }
    end

    def self.erbs_for format, names, allow_missing:
      @erbs_for ||= {}
      k = "#{format}-#{names.join("-")}"
      @erbs_for[k] ||= _erbs_for format, names, allow_missing:
    end

    def self._erbs_for format, names, allow_missing:
      ret = {}

      log_erb = log_level? :higher

      converters = DevBox.converters_to[format] || []
      converters_from = converters.map { _1[:from] }
      format_with_converters_from = [format, *converters_from]
      log "names #{stick :light_green, names.join(" ")} | formats #{stick :light_green, format_with_converters_from.join(" ")}" if log_erb

      names.each do |name|
        name_string = name.to_s
        log stick :onyx, "      #{name_string}#{".*.erb # filtering name  "} #{renderable_names.join(" ")}" if log_erb
        
        name_candidates = renderable_formats_for name_string
        if name_candidates.none?

          if allow_missing
            log stick :light_yellow, "      #{name_string}.#{format}.erb not found, but allow_missing: true" if log_erb
            found = Liza::Unit.erbs_defined.first
          else
            log stick :light_red, "    #{name}.#{format}.erb not found, and allow_missing: false"
            raise RendererNotFound, "ERB #{name}.#{format}.erb not found"
          end

        else

          log stick :onyx, "      #{name_string}#{".*.erb # filtering format "}#{name_candidates.map(&:format).join(" ")}" if log_erb

          found = name_candidates.find do |erb|
            erb_format_sym = erb.format.to_sym
            format_with_converters_from.include? erb_format_sym
          end

          if found
            log stick :light_green, "      #{found.key} found" if log_erb
          else
            if allow_missing
              log stick :light_yellow, "    #{name}.#{format}.erb not found, but allow_missing: true" if log_erb
              found = Liza::Unit.erbs_defined.first
            else
              log stick :light_red, "    #{name}.#{format}.erb not found, and allow_missing: false"
              raise RendererNotFound, "ERB #{name}.#{format}.erb not found"
            end
          end

        end

        ret[name] = found
      end

      ret
    end
  end

end
