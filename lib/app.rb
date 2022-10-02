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

    log "liza #{argv.join(" ").light_green} | lizarb v#{Lizarb::VERSION}"
    puts
    _call_dev if argv[0] == "dev"
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

  #

  def fname_for klass
    # /path/to/liza.rb
    # /path/to/liza
    Object.const_source_location(klass.name)[0][0..-4]
  end

end
