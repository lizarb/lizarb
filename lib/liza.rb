# frozen_string_literal: true

module Liza
  class Error < StandardError; end
  class ConstNotFound < Error; end

  #

  module_function

  def log s
    puts s
  end

  #

  def [] name
    const name
  end

  # Checks Object, each system, then Liza, only returns if they are Liza::Unit descendants
  def const name
    name = name.to_s.camelize.to_sym

    k = const_check_object name
    return k if k

    k = const_check_systems name
    return k if k

    k = const_get_liza name
    return k if k

    nil
  end

  # Checks each system, then Liza, only returns if they are Liza::Unit descendants
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
    App.systems.frozen? or return nil

    for k in App.systems.values.reverse
      next if not k.const_defined? name.to_sym
      kk = k.const(name) if k.constants.include? name
      return kk if is_unit? kk
    end

    nil
  end

  def const_get_liza name
    const_get name
  rescue NameError => _e
    log "Liza const #{name} not found!" if $VERBOSE
    if Lizarb.ruby_supports_raise_cause?
      raise ConstNotFound, name, cause: nil
    else
      raise ConstNotFound, name, []
    end
  end

  def is_unit? kk
    kk && kk < Liza::Unit
  end

end
