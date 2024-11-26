class DevSystem::TestCommand < DevSystem::Command

  def self.get_command_signatures
    [
      {
        name: "",
        description: "# no description",
      }
    ]
  end

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

    _call_silence_other_units
    
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

  def self._call_silence_other_units
    [
      Liza::Part,
      Liza::System,
      Liza::Box,
      Liza::Panel,
      Liza::Controller,
    ].each do |x|
      x.class_eval do
        def self.log(...) super(...) if self == TestCommand end
        def self.puts(...) super(...) if self == TestCommand end
        def log(...) super(...) if self.class == TestCommand end
        def puts(...) super(...) if self.class == TestCommand end
      end
    end
  end

  def self._get_test_classes
    ret = []

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
      if last_namespace != namespace
        puts
        s = namespace.length.positive? ? namespace : "App"
        Liza.log stick :b, " #{s} ".center(140, "-")
        puts
      end
      last_namespace = namespace

      test_class.totals.each do |k, v|
        totals[k] += v.size
      end
      size = 60 - test_class.subject_class.to_s.size
      total_line = test_class.totals.map do |k, v|
        s = "#{k}: #{v.size}"
        s = ":#{k} => #{v.size.to_s.rjust 2}"
        s = stick :b, :white, :light_red, s if k==:errors && v.size.positive?
        s = stick :b, :black, :light_yellow, s if k==:fails && v.size.positive?
        s = stick :b, :white, :light_blue, s if k==:todos && v.size.positive?
        s = stick :b, :light_green, s if k==:passes && v.size.positive?
        s
      end
      total_line = "{ #{ total_line.join(", ") } }"
      Liza.log "#{ColorShell.color_unit test_class.subject_class}#{" " * size} #{total_line}"
    end
    puts
    Liza.log "#{"Total".ljust 60} #{totals}"
    puts
  end

end
