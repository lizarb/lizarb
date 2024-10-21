class Liza::UnitDefiningPart < Liza::Part

  insertion do
    def self.methods_defined
      a = methods - superclass.methods
      a.reject! { _1.to_s[0] == "_" }
      a.sort!
    end

    def self.instance_methods_defined
      a = instance_methods - superclass.instance_methods
      a.reject! { _1.to_s[0] == "_" }
      a.sort!
    end

    def self.methods_for_erroring
      [:define_error, :errors, :raise_error]
    end

    def self.instance_methods_for_erroring
      [:raise_error]
    end

    def self.methods_for_logging
      array = methods_defined.select { _1[0..2] == "log" }.sort
      [*array, :stick, :sticks]
    end

    def self.instance_methods_for_logging
      array = instance_methods_defined.select { _1[0..2] == "log" }.sort
      [*array, :stick, :sticks]
    end

    def self.methods_for_rendering
      methods_defined.select { _1[0..5] == "render" || _1[0..2] == "erb" }.sort
    end

    def self.instance_methods_for_rendering
      instance_methods_defined.select { _1[0..5] == "render" || _1[0..2] == "erb" }.sort
    end

    def self.methods_for_setting
      [:add, :fetch, :get, :set, :settings].sort
    end
  
    def self.instance_methods_for_setting
      [:add, :fetch, :get, :set, :settings].sort
    end
  
    # Define a section
    def self.section(name)
      @current_section = name
    end

    # Retrieve the sections
    def self.sections
      @sections ||= Hash.new { |h, k| h[k] = { class_methods: [], instance_methods: [] } }
    end

    # Hook into method definition to capture instance methods under the current section
    def self.method_added(method_name)
      sections[@current_section || :default][:instance_methods] << method_name
    end

    # Hook into singleton method definition to capture class methods under the current section
    def self.singleton_method_added(method_name)
      sections[@current_section || :default][:class_methods] << method_name
    end
    
  end

end
