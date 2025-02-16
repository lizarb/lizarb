class DevSystem::TestCommand < DevSystem::SimpleCommand

  def before
    super

    set_default_array :domains, AppShell.get_writable_domains.keys
    set_default_boolean :run, true
    
    set_input_array :domains do |default|
      domains = AppShell.get_writable_domains
      title = "Which domains are we going to test?"
      InputShell.pick_domains domains, default, title
    end
  end

  def call_default
    Lizarb.eager_load!
    DevBox[:log].sidebar_size 60
    _call_silence_other_units

    now = Time.now

    app_shell = AppShell.new
    app_shell.filter_by_unit Liza::Test

    domains = simple_array(:domains)
    log "domains = #{domains}"
    app_shell.filter_by_domains domains

    name = simple_args[0]
    app_shell.filter_by_starting_with name if name

    set_input_boolean :run do |default|
      InputShell.yes? "Do you want to run the tests?", default: default
    end

    should_run = simple_boolean(:run)
    test_classes = app_shell.lists.flatten
    log "Testing #{test_classes}"
    _call_testing test_classes if should_run
    log "Done Testing (#{now.diff}s)"

    puts

    log "Counting #{test_classes.count} Test Classes"
    _call_counting app_shell
    log "Done Counting (#{now.diff}s)"
  end

  def _call_silence_other_units
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

  def _call_testing test_classes
    i, count = 0, test_classes.count
    for test_class in test_classes
      test_class.call i+=1, count
    end
  end

  def _call_counting(app_shell)
    puts
    Liza.log ""
    Liza.log stick :b, " TEST TOTALS ".center(120, "-")
    Liza.log ""
    puts
    totals = Hash.new { 0 }
    last_namespace = nil
    app_shell.get_domains.each do |domain|
      next if domain.empty?
      puts
      puts typo.h1 domain.name.to_s, domain.color, length: 120
      puts

      domain.layers.each do |layer|
        next if layer.objects.empty?

        m = "h#{layer.level}"
        puts typo.send m, layer.name.to_s, layer.color, length: 120 unless layer.level == 1

        puts stick layer.color, layer.path
        puts

        layer.objects.each do |object|
          object.totals.each do |k, v|
            totals[k] += v.size
          end
          size = 60 - object.to_s.size
          total_line = object.totals.map do |k, v|
            s = "#{k}: #{v.size}"
            s = ":#{k} => #{v.size.to_s.rjust 2}"
            s = stick :b, :white, :light_red, s    if k==:errors && v.size.positive?
            s = stick :b, :black, :light_yellow, s if k==:fails  && v.size.positive?
            s = stick :b, :white, :light_blue, s   if k==:todos  && v.size.positive?
            s = stick :b, :light_green, s          if k==:passes && v.size.positive?
            s
          end
          total_line = "{ #{ total_line.join(", ") } }"
          Liza.log "#{typo.color_class object}#{" " * size} #{total_line}"
        end
        puts
      end
    end
    puts
    totals_line = totals.map do |k, v|
      s = "#{k}: #{v}"
      s = ":#{k} => #{v.to_s.rjust 2}"
      s = stick :b, :white, :light_red, s    if k==:errors && v.positive?
      s = stick :b, :black, :light_yellow, s if k==:fails  && v.positive?
      s = stick :b, :white, :light_blue, s   if k==:todos  && v.positive?
      s = stick :b, :black, :light_green, s  if k==:passes && v.positive?
      s
    end
    totals_line = "{ #{ totals_line.join(", ") } }"
    Liza.log "#{"Total".ljust 60} #{totals_line}"
    puts
  end

end
