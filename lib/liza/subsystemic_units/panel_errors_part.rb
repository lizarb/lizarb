class Liza::PanelErrorsPart < Liza::Part
  insertion do

    #

    def rescue_from(*args, &block)
      case args.count
      when 1

        e_class = args[0]
        e_class = _rescue_from_parse_error(e_class) if Symbol === e_class

        callable = block if block_given?
        callable ||= :"#{args[0]}_#{key}"

      when 2

        e_class = args[0]
        e_class = _rescue_from_parse_error(e_class) if Symbol === e_class

        callable = :"#{args[1]}_#{key}"
        raise ArgumentError, "wrong number of arguments (2 arguments and a block is not allowed)" if block_given?

      else
      
        raise ArgumentError, "wrong number of arguments (given #{args.count}, expected 1..2)"
      
      end

      unless e_class
        msg = "args #{args} parsed to #{e_class} (expected a descendant of Exception)"
        raise ArgumentError, msg
      end

      e_class_is_exception = e_class.ancestors.include? Exception
      unless e_class_is_exception
        msg = "args #{args} parsed to #{e_class} (expected a descendant of Exception)"
        raise ArgumentError, msg
      end

      rescuer = Rescuer.new
      rescuer[:exception_class] = e_class
      rescuer[:callable] = callable

      rescuers.push(rescuer)
    end

    def _rescue_from_parse_error(symbol)
      s = "#{symbol}_error".camelcase
      self.class.const_get(s)
    rescue NameError => e
      msg = "rescue_from parsed to #{self.class}::#{s} which does not exist"
      puts stick :light_red, msg
      raise e, msg, caller
    end

    #

    def rescuers
      @rescuers ||= []
    end

    #

    def rescue_from_panel(exception, env)
      rescuer = _rescue_from_panel_find exception
      raise exception.class, exception.message, caller[1..-1] unless rescuer

      ret = nil

      log :higher, "rescuer = #{rescuer.inspect}"
      case env
      when Array
        env.push(rescuer)
        rescuer[:args] = env
        ret = rescuer.call
      when Hash
        env[:rescuer] = rescuer
        rescuer[:env] = env
        ret = rescuer.call
      else
        raise ArgumentError, "wrong argument type #{with.class} (expected Array or Hash)"
      end

      ret
    end

    def _rescue_from_panel_find(exception)
      rescuer = rescuers.reverse.find { exception.class.ancestors.include? _1[:exception_class] }
      log :higher, "rescuer = #{rescuer.inspect}"
      return nil unless rescuer
      rescuer = rescuer.dup
      rescuer[:exception] = exception
      rescuer
    end

    #

    class Rescuer < Hash
      def call
        if self[:block]
          self[:block].call self
        elsif self[:env]
          callable.call self[:env]
        elsif self[:args]
          callable.call self[:args]
        else
          raise "not expected"
        end
      end

      def callable
        @callable ||= (self[:callable].is_a? Symbol) ? Liza.const(self[:callable]) : self[:callable]
      end
    end

  end
end
