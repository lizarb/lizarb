class Liza::UnitErroringPart < Liza::Part

  insertion do
    def self.errors
      fetch(:errors) { {} }
    end

    def self.define_error(error_key, &block)
      self.const_set :Error, Class.new(StandardError) unless defined? Error

      error_class = Error
      error_class = Class.new error_class
      error_class = self.const_set "#{error_key.to_s.camelcase}Error", error_class
      
      errors[error_key] = [error_class, block]
    end

    def self.raise_error(error_key, *args, kaller: caller)
      error, message_block = errors[error_key]
      raise error, message_block.call(args), kaller
    end

    def raise_error(error_key, *args, kaller: caller)
      error, message_block = self.class.errors[error_key]
      raise error, message_block.call(args), kaller
    end

  end

end
