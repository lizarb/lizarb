# frozen_string_literal: true

module Liza
  class Error < StandardError; end

  #

  module_function

  def log s
    puts s.bold
  end

  #

end
