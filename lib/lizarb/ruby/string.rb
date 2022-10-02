# frozen_string_literal: true

class String
  alias lpartition partition

  def camelize
    split("_").map { |s| "#{s[0].upcase}#{s[1..-1]}" }.join("")
  end
end
