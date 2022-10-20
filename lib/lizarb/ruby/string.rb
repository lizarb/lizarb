# frozen_string_literal: true

class String
  alias lpartition partition

  def camelize
    split("_").map { |s| "#{s[0].upcase}#{s[1..-1]}" }.join("")
  end

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
