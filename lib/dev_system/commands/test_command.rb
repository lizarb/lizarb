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
    silence!

    now = Time.now

    app_shell = build_filters

    set_input_boolean :run do |default|
      InputShell.yes? "Do you want to run the tests?", default: default
    end

    should_run = simple_boolean(:run)
    test_classes = app_shell.get_lists.flatten
    log "Testing #{test_classes}"
    _call_testing test_classes if should_run
    log "Done Testing (#{time_diff now}s)"

    unsilence!

    puts

    log "Counting #{test_classes.count} Test Classes"
    _call_counting app_shell
    log "Done Counting (#{time_diff now}s)"
  end

  def silence!
    other_units.each do |x|
      x.class_eval do
        def self.log(...) end
        def self.puts(...) end
        def log(...) end
        def puts(...) end
      end unless x == DevSystem::TestCommand
    end
  end

  def unsilence!
    other_units.each do |x|
      x.class_eval do
        self.singleton_class.remove_method :log
        self.singleton_class.remove_method :puts
        self.remove_method :log
        self.remove_method :puts
        # undef :log
        # undef :puts
        # def self.log(...) super end
        # def self.puts(...) super end
        # def log(...) super end
        # def puts(...) super end
      end unless x == DevSystem::TestCommand
    end
  end

  def other_units
    [
      Liza::Part,
      Liza::System,
      Liza::Box,
      Liza::Panel,
      Liza::Controller,
    ]
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
    Liza.log stick :b, :black, :white, " TEST TOTALS ".center(120, "-")
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

  def build_filters
    app_shell = AppShell.new
    app_shell.filter_by_unit Liza::Test

    domains = simple_array(:domains)
    log "domains = #{domains}"
    app_shell.filter_by_domains domains

    case simple_args.count
    when 0
      log "No filter"
    when 1
      name = simple_args[0]
      log "Filter by name starting with #{name}"
      app_shell.filter_by_starting_with name
    else
      case simple_args[0]
      when "all"
        log "Filter by all names"
        app_shell.filter_by_including_all_names simple_args[1..]
      else
        app_shell.filter_by_including_any_name simple_args
      end
    end

    app_shell
  end

end
