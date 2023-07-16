class DevSystem::BenchGenerator < DevSystem::Generator

  # lizarb bench NAME
  # lizarb bench NAME a b c

  def self.call(args)
    log "args = #{args.inspect}"

    name = args.shift || raise("args[0] should contain NAME")
    name = name.snakecase

    app_name = $APP

    generators = _build_generators name, app_name, args
    generators.each do |generator|
      generator.generate!
    end
  end

  def self._build_generators(name, app_name, args)
    ret = []

    has_sorted_bench = File.exist? "#{app_name}/dev/benches/sorted_bench.rb"

    ret << new.tap do |instance|
      instance.instance_exec do
        @name = name
        @class_name = "#{name.camelize}Bench"
        @superclass_name = "Liza::Bench"
        @superclass_name = "SortedBench" if has_sorted_bench
        @template = :bench
        @path = "#{app_name}/dev/benches/#{name.snakecase}_bench.rb"
        @args = args
      end
    end

    ret << new.tap do |instance|
      instance.instance_exec do
        @name = name
        @class_name = "#{name.camelize}BenchTest"
        @superclass_name = "Liza::BenchTest"
        @superclass_name = "SortedBenchTest" if has_sorted_bench
        @template = :bench_test
        @path = "#{app_name}/dev/benches/#{name.snakecase}_bench_test.rb"
        @args = args
      end
    end

    ret
  end

  # lizarb bench:install

  def self.install(args)
    log "args = #{args.inspect}"

    generators = _build_installer_generators(args)
    generators.each do |generator|
      generator.generate!
    end
  end

  def self._build_installer_generators(args)
    ret = []

    app_name = $APP

    ret << new.tap do |instance|
      instance.instance_exec do
        source = "#{Lizarb::GEM_DIR}/app_benches/dev/benches/sorted_bench.rb"
        @content = TextShell.read source

        @path = "#{app_name}/dev/benches/sorted_bench.rb"
        @args = args
      end
    end

    ret << new.tap do |instance|
      instance.instance_exec do
        source = "#{Lizarb::GEM_DIR}/app_benches/dev/benches/sorted_bench_test.rb"
        @content = TextShell.read source

        @path = "#{app_name}/dev/benches/sorted_bench_test.rb"
        @args = args
      end
    end

    ret
  end

  # lizarb bench:examples

  def self.examples(args)
    log "args = #{args.inspect}"

    generators = _build_example_generators(args)
    generators.each do |generator|
      generator.generate!
    end
  end

  def self._build_example_generators(args)
    ret = []

    app_name = $APP

    list = Dir["#{Lizarb::GEM_DIR}/app_benches/dev/benches/*.rb"]
    list.each do |source|
      ret << new.tap do |instance|
        instance.instance_exec do
          @content = TextShell.read source

          fname = source.split("/").last
  
          @path = "#{app_name}/dev/benches/#{fname}"
          @args = args
        end
      end
    end

    ret
  end

  #

  def generate!
    @format = :rb
    @content ||= render :unit, @template

    if _should_generate?
      TextShell.write @path, @content
    end
  end

  def _should_generate?
    must_ask_to_overwrite = File.exist? @path

    return true unless must_ask_to_overwrite
  
    _output_diff
    log "#{@path} already exists. #{"Do you want to overwrite?".underline}"

    title = "Do you want to overwrite #{@path} ?"
    options = ["Yes", "No"]

    x = DevBox.pick_one title, options
    x == "Yes"
  end

  def _output_diff
    log "current content".red.underline
    puts File.read(@path).red

    log "new content".green.underline
    puts @content.green
  end
end

__END__

# view unit.rb.erb
class <%= @class_name %> < <%= @superclass_name %>
  <%= render -%>
end
# view bench.rb.erb

  # lizarb bench <%= @name %>

  def self.setup *args; end
  def self.mark *args; end

  setup do
    N = 1_000_000
    # N = 10_000_000
    # N = 100_000_000
  end
<% if @args.empty? %>
  mark "alternative 1" do
    i = 0

    while (i += 1) <= N
      a = "1".to_sym
    end
  end

  mark "alternative 2" do
    i = 0

    while (i += 1) <= N
      a = :"1"
    end
  end
<% else %>
<% @args.each do |arg| -%>
  mark "<%= arg %>" do
    i = 0

    while (i += 1) <= N
      a = (1..N).sample
    end
  end

<% end -%>
<% end -%>
# view bench_test.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end

