class DevSystem::TestCommand < DevSystem::Command

  def self.call args
    log "args = #{args.inspect}"

    now = Time.now
    test_classes = Liza::Test.descendants

    if args.any?
      test_classes = test_classes.select { |tc| args.any? { tc.source_location_radical.snakecase.include? _1.snakecase } }
    end

    _call_silence_base_units
    
    if Lizarb.is_app_dir
      test_classes = test_classes.select { |tc| tc.source_location[0].include? Lizarb.app_dir.to_s }
    end

    test_classes = _call_sort test_classes

    log "Testing #{test_classes}"
    _call_testing test_classes
    log "Done Testing (#{now.diff}s)"

    puts

    log "Counting #{test_classes.count} Test Classes"
    _call_counting test_classes
    log "Done Counting (#{now.diff}s)"
  end

  def self._call_silence_base_units
    [
      Liza::Box,
      Liza::Panel,
      Liza::Controller,
    ].each do |x|
      def x.log(...) end
      def x.puts(...) end
    end
  end

  def self._call_sort test_classes
    test_classes.sort_by! &:name

    proc_namespaced = proc { |tc| tc.name.include? "::" }
    proc_liza = proc { |tc| tc.name[0..3] == "Liza" }

    tc_app        = test_classes.reject(&proc_namespaced)
    tc_namespaced = test_classes.select(&proc_namespaced)

    tc_liza   = tc_namespaced.select(&proc_liza)
    tc_system = tc_namespaced.reject(&proc_liza)

    tc_app.sort_by! &:source_location
    tc_liza.sort_by! &:source_location

    [tc_liza, tc_system, tc_app].flatten
  end

  def self._call_testing test_classes
    i, count = 0, test_classes.count
    for test_class in test_classes
      test_class.call i+=1, count
    end
  end


  def self._call_counting test_classes
    puts
    Liza.log ""
    Liza.log stick :b, " TEST TOTALS ".center(140, "-")
    Liza.log ""
    puts
    totals = Hash.new { 0 }
    last_namespace = nil
    test_classes.each do |test_class|
      namespace = test_class.first_namespace
      puts if last_namespace != namespace
      last_namespace = namespace

      test_class.totals.each do |k, v|
        totals[k] += v.size
      end
      size = 60 - test_class.subject_class.to_s.size
      Liza.log "#{_color_unit test_class.subject_class}#{".totals".ljust size} #{test_class.totals.map { |k, v| [k, v.size] }.to_h}"
    end
    puts
    Liza.log "#{"Total".ljust 60} #{totals}"
    puts
  end

  def self._color_unit klass
    return klass.to_s unless klass < Liza::Unit
    return klass.to_s if klass.superclass == Liza::Unit

    ret = ""
    namespace, _sep, classname = klass.name.rpartition('::')
    unless namespace.empty?
      system_color = klass.system.color
      ret << stick(namespace, system_color, :b).to_s
      ret << "::"
    end

    klass = klass.division if klass.is_a? Liza::Controller
    unit_color = nil
    unit_color = klass.system.color

    ret << stick(classname, unit_color).to_s
    ret
  end

end
