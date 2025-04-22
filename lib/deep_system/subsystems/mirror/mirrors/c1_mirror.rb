class DeepSystem::C1Mirror < DeepSystem::Mirror

  def self.include_c_header(*)
  end

  # def self.embeded_methods?
  #   defined? @embeded_methods
  # end

  def self.embeded_methods
    @embeded_methods ||= []
  end

  def self.cdef(rb_method, *args)
    # raise "You can only use cdef in a system" unless system_namespace?
    # singleton = false
    # code = args.pop

    # embeded_methods << {singleton: , rb_method: , args: , code: ,}
    define_method(rb_method) do |*args|
      Time.now
    end
  end

  def self.cdef_self(rb_method, *args)
    # raise "You can only use cdef in a system" unless system_namespace?
    # singleton = true
    # code = args.pop

    # embeded_methods << {singleton: , rb_method: , args: , code: ,}
    define_singleton_method(rb_method) do |*args|
      Time.now
    end
  end

  # def self.jdef(rb_method, *args)
  #   raise "You can only use jdef in a system" unless system_namespace?
  #   singleton = false
  #   code = args.pop

  #   embeded_methods << {singleton: , rb_method: , args: , code: ,}
  # end

  # def self.jdef_self(rb_method, *args)
  #   raise "You can only use jdef in a system" unless system_namespace?
  #   singleton = true
  #   code = args.pop

  #   embeded_methods << {singleton: , rb_method: , args: , code: ,}
  # end

  def self.compile!
    log "compile #{system}"
    LabBox[:compiler].call(system)
  end

  def self.system_namespace?
    name.split("::").first.end_with?("System")
  end

  # section :actions


  # # Mirror.call action: :default
  # # liza mirror name action_1 action_2 action_3
  # def self.call_default
  #   # your code here
  #   call(action: :default)
  #   # your code here
  # end


end
