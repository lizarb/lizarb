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
    name = name.to_s.camelize.to_sym

    k = const_check_object name
    return k if k

    k = const_get name
    return k if k

    nil
  end

  # constants missing from Liza will be looked up in all systems
  def const_missing name
    k = const_check_systems name
    return k if k

    super
  end

  def const_check_object name
    return if not Object.const_defined? name
    kk = Object.const_get name
    return kk if is_unit? kk

    nil
  end

  def const_check_systems name
    for k in App.systems.values.reverse
      next if not k.const_defined? name.to_sym
      kk = k.const(name) if k.constants.include? name
      return kk if is_unit? kk
    end

    nil
  end

  def is_unit? kk
    kk && kk < Liza::Unit
  end

end
