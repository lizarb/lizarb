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

  # constants missing from Liza will be looked up in all systems
  def const_missing name
    for k in App.systems.values.reverse
      return k.const_get(name) if k.const_defined? name
    end

    super
  end

end
