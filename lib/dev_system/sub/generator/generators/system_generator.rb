class DevSystem::SystemGenerator < DevSystem::Generator

  # lizarb system NAME

  def self.call(args)
    log "args = #{args.inspect}"

    name = args.shift || raise("args[0] should contain NAME")
    name = name.snakecase

    generators = _build_generators name, args
    generators.each do |generator|
      generator.generate!
    end
  end

  def self._build_generators(name, args)
    ret = []

    ret << new.tap do |instance|
      instance.instance_exec do
        @name = name
        @class_name = "#{name.camelize}System"
        @superclass_name = "Liza::System"
        @template = :system
        @path = "lib/#{name.snakecase}_system.rb"
        @args = args
      end
    end

    ret << new.tap do |instance|
      instance.instance_exec do
        @name = name
        @class_name = "#{name.camelize}System::#{name.camelize}Box"
        @superclass_name = "Liza::Box"
        @template = :box
        @path = "lib/#{name.snakecase}_system/#{name.snakecase}_box.rb"
        @args = args
      end
    end

    ret << new.tap do |instance|
      instance.instance_exec do
        @name = name
        @subject_class_name = "#{name.camelize}System::#{name.camelize}Box"
        @class_name = "#{name.camelize}System::#{name.camelize}BoxTest"
        @superclass_name = "Liza::BoxTest"
        @template = :box_test
        @path = "lib/#{name.snakecase}_system/#{name.snakecase}_box_test.rb"
        @args = args
      end
    end

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
    assert_equality <%= @subject_class_name %>, subject_class
    assert_equality <%= @subject_class_name %>, subject.class
  end

