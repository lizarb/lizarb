class MacroChildCommand < MacroParentCommand

  class_macro_method_1 :important_thing
  class_macro_method_2 :other_thing
  class_macro_method_3 :other_important_thing
  class_macro_method_4 :ruby_is_awesome

  #

  def call(args)
    log :higher, "Called #{self}.#{__method__} (which has @init_args #{@init_args}) with args #{args}"

    if @@class_macro_3
      @result << :YES_from_instance_call
    else
      @result << :NO_from_instance_call
    end

    @result << helper_method(args)
  end

  def helper_method(args)
    log :higher, "Called #{self}.#{__method__} (which has @init_args #{@init_args}) with args #{args}"

    if @@class_macro_4
      :Yes_from_helper_method
    else
      :No_from_helper_method
    end
  end

end
