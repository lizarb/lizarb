# frozen_string_literal: true

class String
  alias lpartition partition

  def camelcase
    split("_").map { |s| "#{s[0].to_s.upcase}#{s[1..-1]}" }.join("")
  end

  alias camelize camelcase

  def snakecase
    gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .downcase
  end
  
  alias snakefy snakecase

  def rjust_blanks length
    rjust length, " "
  end

  def rjust_zeroes length
    rjust length, "0"
  end

  def ljust_blanks length
    ljust length, " "
  end

  def ljust_zeroes length
    ljust length, "0"
  end
end
