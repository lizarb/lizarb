class DevSystem::GeneratorGenerator < Liza::Generator

  # lizarb generator NAME

  def self.call args
    log "args = #{args.inspect}"
    log "This generator in under construction. Use 'lizarb generator:examples' instead."
  end

  # lizarb generator:install

  def self.install(args)
    log "args = #{args.inspect}"
    log "This generator in under construction. Use 'lizarb generator:examples' instead."
  end

  # lizarb generator:examples

  def self.examples(args)
    log "args = #{args.inspect}"

    generators = _build_example_generators args
    generators.each do |generator|
      generator.generate!
    end
  end

  def self._build_example_generators(args)
    ret = []

    app_name = $APP

    root_path = Lizarb::IS_LIZ_DIR ? Lizarb::CUR_DIR : Lizarb::GEM_DIR

    #

    ret << new.tap do |instance|
      instance.instance_exec do
        @content = TextShell.read "#{root_path}/lib/dev_system/sub/bench/generators/bench_generator.rb"

        @content = @content.split("\n").each do |line|
          line.gsub! "class DevSystem::BenchGenerator < DevSystem::Generator", "class BenchGenerator < Liza::BenchGenerator"
        end.join("\n")

        @path = "#{app_name}/dev/generators/bench_generator.rb"
        @args = args
      end
    end

    ret << new.tap do |instance|
      instance.instance_exec do
        @content = TextShell.read "#{root_path}/lib/dev_system/sub/bench/generators/bench_generator_test.rb"

        @content = @content.split("\n").each do |line|
          line.gsub! "class DevSystem::BenchGeneratorTest < DevSystem::GeneratorTest", "class BenchGeneratorTest < Liza::BenchGeneratorTest"
          line.gsub! "assert subject_class == DevSystem::BenchGenerator", "assert subject_class == ::BenchGenerator"
        end.join("\n")

        @path = "#{app_name}/dev/generators/bench_generator_test.rb"
        @args = args
      end
    end

    #

    ret << new.tap do |instance|
      instance.instance_exec do
        @content = TextShell.read "#{root_path}/lib/dev_system/sub/command/generators/command_generator.rb"

        @content = @content.split("\n").each do |line|
          line.gsub! "class DevSystem::CommandGenerator < DevSystem::ControllerGenerator", "class CommandGenerator < Liza::CommandGenerator"
        end.join("\n")

        @path = "#{app_name}/dev/generators/command_generator.rb"
        @args = args
      end
    end

    ret << new.tap do |instance|
      instance.instance_exec do
        @content = TextShell.read "#{root_path}/lib/dev_system/sub/command/generators/command_generator_test.rb"

        @content = @content.split("\n").each do |line|
          line.gsub! "class DevSystem::CommandGeneratorTest < DevSystem::ControllerGeneratorTest", "class CommandGeneratorTest < Liza::CommandGeneratorTest"
          line.gsub! "assert subject_class == DevSystem::CommandGenerator", "assert subject_class == ::CommandGenerator"
        end.join("\n")

        @path = "#{app_name}/dev/generators/command_generator_test.rb"
        @args = args
      end
    end

    #

    ret << new.tap do |instance|
      instance.instance_exec do
        @content = TextShell.read "#{root_path}/lib/dev_system/sub/generator/generators/system_generator.rb"

        @content = @content.split("\n").each do |line|
          line.gsub! "class DevSystem::SystemGenerator < DevSystem::Generator", "class SystemGenerator < Liza::SystemGenerator"
        end.join("\n")

        @path = "#{app_name}/dev/generators/system_generator.rb"
        @args = args
      end
    end

    ret << new.tap do |instance|
      instance.instance_exec do
        @content = TextShell.read "#{root_path}/lib/dev_system/sub/generator/generators/system_generator_test.rb"

        @content = @content.split("\n").each do |line|
          line.gsub! "class DevSystem::SystemGeneratorTest < DevSystem::GeneratorTest", "class SystemGeneratorTest < Liza::SystemGeneratorTest"
          line.gsub! "assert subject_class == DevSystem::SystemGenerator", "assert subject_class == ::SystemGenerator"
        end.join("\n")

        @path = "#{app_name}/dev/generators/system_generator_test.rb"
        @args = args
      end
    end

    #

    ret
  end

  #

  def generate!
    @content ||= render :unit, @template, format: :rb
    TextShell.write @path, @content if _should_generate?
  end

  def _should_generate?
    found = File.exist? @path
    return true if not found

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
# view system.rb.erb
class Error < Liza::Error; end

  #

  set :log_color, :white

# view box.rb.erb

  #

# view box_test.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end

