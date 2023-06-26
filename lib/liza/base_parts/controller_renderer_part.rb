class Liza::ControllerRendererPart < Liza::Part

  class Error < Liza::Error; end
  class RendererNotFound < Error; end
  class EmptyRenderStack < Error; end

  EMPTY_RENDER_STACK_MESSAGE = <<~STRING
You called render without ERB keys,
but the render stack is empty.
Did you forget to add ERB keys?
  STRING

  insertion do
    # EXTENSION

    def self.renderer
      Liza::ControllerRendererPart::Extension
    end

    def renderer
      @renderer ||= self.class.renderer.new self
    end

    # CLASS

    def self.controller_ancestors
      ancestors.take_while { |k| k != Liza::Controller }
    end

    def self.render_paths
      @render_paths ||= controller_ancestors.map &:source_location_radical
    end

    def render_paths
      self.class.render_paths
    end

    def self.renderers
      @renderers ||=
        LERB.load(source_location_radical)
            .map { |lerb| [lerb.key, lerb] }
            .to_h
    end

    # INSTANCE

    def render_controller *keys
      if keys.any?
        _log_render_in keys
        renderer.render keys, binding, self
      elsif renderer.stack.any?
        renderer.stack.pop
      else
        raise EmptyRenderStack, EMPTY_RENDER_STACK_MESSAGE, caller
      end
    end

    def _log_render_in keys
      if renderer.stack.any?
        log "render ↓ #{keys.join ", "}"
      else
        log "render #{"→ " * keys.size}#{keys.join ", "}"
      end
    end
  end

  extension do
    # CLASS

    def self.log(...)
      solder.log(...)
    end

    # INSTANCE

    def log(...)
      self.class.log(...)
    end

    def erb_lists
      @erb_lists ||= []
    end

    def stack
      @stack ||= []
    end

    def render keys, the_binding, receiver
      erbs = find_erbs_for(keys).to_a

      erbs.reverse.each do |key, erb|
        t = Time.now
        s = erb.result the_binding, receiver
        _log_render_out key, s.length, t.diff
        s = wrap_comment_tags s, erb if App.mode == :code && erb.tags?
        s = DevBox.convert erb.format, s

        stack.push s
      end

      stack.pop
    end

    def find_erbs_for keys
      ret = {}
      keys.each do |key|
        key = "#{key}.erb"

        controller = solder.class.controller_ancestors.
          find { |controller| controller.renderers.has_key? key }

        if controller
          ret[key] = controller.renderers[key]
        else
          raise_renderer_not_found key
        end
      end

      ret
    end

    def raise_renderer_not_found key
      render_paths = solder.render_paths.map { |s| "  #{s}/#{"#{key}".red}" }.join
      raise RendererNotFound,  %|Failed to find ERB #{key}
Failed to find ERB #{"#{key}".red} in #{solder.class}.render_paths
#{render_paths}|
    end

    def _log_render_out key, length, t
      if stack.any?
        log "render #{"↑ #{key}".ljust_blanks 20} with #{length.to_s.rjust_blanks 4} characters in #{t}s"
      else
        log "render #{"← #{key}".ljust_blanks 20} with #{length.to_s.rjust_blanks 4} characters in #{t}s"
      end
    end

    def wrap_comment_tags s, erb
      "<!-- #{erb.filename.split("/").last}:#{erb.lineno} -->\n#{s}\n<!-- #{erb.filename.split("/").last} -->"
    end

  end
end
