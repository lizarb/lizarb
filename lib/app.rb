module App
  class Error < StandardError; end

  #

  module_function

  def log s
    puts s.bold
  end

  # called from "#{APP_DIR}/app"
  def call argv, &block
    instance_exec &block

    setup_env
    setup_bundle
    setup_liza

    puts
    _call_dev if argv[0] == "dev"
    _call_test if argv[0] == "test"
    puts
  end

  def setup_env
    require "dotenv"
    Dotenv.load "app.#{mode}.env", "app.env"
  end

  def setup_bundle
    require "bundler/setup"
    Bundler.require :default
  end

  def setup_liza
    require "liza"

    @loaders << loader = Zeitwerk::Loader.new
    loader.tag = Liza.to_s

    # ORDER MATTERS: IGNORE, COLLAPSE, PUSH
    loader.collapse "#{fname_for Liza}/**/*"
    loader.push_dir "#{fname_for Liza}", namespace: Liza

    loader.enable_reloading
    loader.setup
  end

  # loaders

  @loaders = []
  @mutex = Mutex.new

  def reload &block
    @mutex.synchronize do
      @loaders.map &:reload
      yield if block_given?
    end

    true
  end

  def eager_load_all
    Zeitwerk::Loader.eager_load_all
  end

  # mode

  def mode
    @mode ||= ENV["LIZA_MODE"] ||= "code"
  end

  # dev

  def _call_dev
    # https://github.com/ruby/ruby/blob/master/lib/irb.rb
    require "irb"

    IRB.setup(nil)
    workspace = IRB::WorkSpace.new(binding)
    irb = IRB::Irb.new(workspace)
    IRB.conf[:MAIN_CONTEXT] = irb.context

    irb.eval_input
  end

  # test

  def _call_test
    now = Time.now

    App.eager_load_all
    test_classes = Liza::Test.descendants

    log "Testing #{test_classes}"
    _call_test_testing test_classes
    log "Done Testing (#{now.diff}s)"

    puts

    log "Counting #{test_classes.count} Test Classes"
    _call_test_counting test_classes
    log "Done Counting (#{now.diff}s)"
  end

  def _call_test_testing test_classes
    i, count = 0, test_classes.count
    for test_class in test_classes
      test_class.call i+=1, count
    end
  end

  def _call_test_counting test_classes
    puts
    totals = Hash.new { 0 }
    test_classes.each do |test_class|
      test_class.totals.each do |k, v|
        totals[k] += v.size
      end
      log "  #{test_class}.totals #{test_class.totals.map { |k, v| [k, v.size] }.to_h}"
    end
    puts
    log "  Total #{totals}"
    puts
  end

  # parts

  def connect_part part_klass, key
    klass = Liza.const "#{key}_part"

    log "CONNECTING PART #{part_klass.to_s.rjust 25}.part :#{key}"

    if klass.insertion
      part_klass.class_exec &klass.insertion
    end

    if klass.extension
      klass.const_set :Extension, Class.new(Liza::PartExtension)
      klass::Extension.class_exec &klass.extension
    end
  end

  #

  def fname_for klass
    # /path/to/liza.rb
    # /path/to/liza
    Object.const_source_location(klass.name)[0][0..-4]
  end

end
