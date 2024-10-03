class DevSystem::TestCommand < DevSystem::Command

  def self.call env
    super
    Lizarb.eager_load!
    DevBox[:log].sidebar_size 60

    args = env[:args]
    log "args = #{args.inspect}"

    now = Time.now
    test_classes = _get_test_classes

    if args.any?
      test_classes = test_classes.select { |tc| args.any? { tc.source_location_radical.snakecase.include? _1.snakecase } }
    end

    _call_silence_base_units
    
    if Lizarb.is_app_dir
      test_classes = test_classes.select { |tc| tc.source_location[0].include? Lizarb.app_dir.to_s }
    end

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
      def x.log(...) super(...) if self == TestCommand end
      def x.puts(...) super(...) if self == TestCommand end
    end
  end

  def self._get_test_classes
    ret = []
    app = AppShell.new

    only_tests = proc { |klasses| klasses.select { _1 < Liza::Test } }

    list = AppShell.consts[:liza].to_a
    list = [list[-1]] + list[0..-2]
    list[0][1].tap do
      _1.delete ObjectTest
      _1.delete AppTest
      list[0][1] = [ObjectTest, *_1, AppTest]
    end
    list.each do |category, klasses|
      ret += only_tests.call klasses
    end

    AppShell.consts[:systems].each do |system_name, tree_system|
      system = tree_system["system"][0]

      ret += only_tests.call tree_system["system"]
      ret += only_tests.call tree_system["box"]
      tree_system["controllers"].each do |family, klasses|
        ret += only_tests.call klasses
      end

      tree_system["subsystems"].each do |subsystem, tree_subsystem|
        ret += only_tests.call tree_subsystem["panel"]
        ret += only_tests.call tree_subsystem["controller"]
        tree_subsystem["controllers"].each do |controller_class, klasses|
          ret += only_tests.call klasses
        end
      end
    end

    AppShell.consts[:app].each do |system_name, tree_system|
      system = Liza.const "#{system_name}_system"
      tree_system["controllers"].each do |family, structure|
        structure.each do |division, klasses|
          ret += only_tests.call klasses
        end
      end
    end

    ret
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
      Liza.log "#{_color_unit test_class.subject_class}#{" " * size} #{test_class.totals.map { |k, v| [k, v.size] }.to_h}"
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

    klass = klass.subsystem if klass < Liza::Controller
    unit_color = nil
    unit_color = klass.system.color

    ret << stick(classname, unit_color).to_s
    ret
  end

end
