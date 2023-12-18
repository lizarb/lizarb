# frozen_string_literal: true

class Time
  def diff digits = 4
    raise ArgumentError, "digits must be between 1 and 4" unless digits.between? 1, 4
    f = (self.class.now.to_f - to_f).floor(digits)
    u, d = f.to_s.split "."
    "#{u}.#{d.ljust digits, "0"}"
  end
end
