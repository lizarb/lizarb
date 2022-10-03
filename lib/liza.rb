# frozen_string_literal: true

module Liza
  class Error < StandardError; end

  #

  module_function

  def log s
    puts s.bold
  end

  #

  # After checking the top-level namespace, looks up the Liza namespace
  def const name
    name = name.to_s.camelize

    return Object.const_get name if Object.const_defined? name

    const_get name
  end

end
