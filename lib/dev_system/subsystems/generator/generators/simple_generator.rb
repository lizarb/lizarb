class DevSystem::SimpleGenerator < DevSystem::BaseGenerator

  section :filters

  def self.before_instance_calls()= fetch(:before_instance_calls) { [] }

  def self.before_instance_call(method, *args, &block)
    log :higher, "before_instance_call save #{method}, #{args}, #{block}"
    before_instance_calls << [method, args, block]
  end

  def before
    super

    before_instance_calls
  end

  def before_instance_calls
    self.class.before_instance_calls.each do |method, args, block|
      log :higher, "before_instance_call send #{method}, #{args}, #{block}"
      send method, *args, &block
    end
  end
  
  section :panel

  def inform
    log :lowest, "informing #{mapper.changes.count} changes"

    mapper.changes.each do |fname, data|
      mapper.changes.delete fname if data[:before] == data[:after]
    end
    
    mapper.changes.each do |fname, data|
      puts_line
      
      action = "updating"
      action = "creating" if data[:before] == ""
      action = "deleting" if data[:after] == ""

      diff = {
        "+": (data[:after].split("\n") - data[:before].split("\n")).count,
        "-": (data[:before].split("\n") - data[:after].split("\n")).count,
      }

      bit = diff.map { "#{_1}#{_2}" }.join(" ")
      relative = Pathname(fname).relative_path_from(App.root)
      string = "#{action.ljust 8} | #{"#{bit}".rjust 8} lines | #{relative}"
      log :lowest, string

      if log_level? :low
        puts relative
        LineDiffShell.log_diff(data[:before].split("\n"), data[:after].split("\n")) if diff.values.sum.positive?
      end
    end
  end

  def save
    puts_line
    diff = {
      "+": mapper.changes.map { _2[:after].split("\n").count }.sum,
      "-": mapper.changes.map { _2[:before].split("\n").count }.sum,
    }
    log "saving #{mapper.changes.count} files changed: #{diff[:"+"]} insertions(+), #{diff[:"-"]} deletions(-)"

    choices = mapper.changes.keys.map { [_1, _1] }.to_h
    if command.simple_boolean :confirm
      answers = choices.keys
    else
      answers = InputShell.multi_select "Approve all changes?", choices
    end

    #
    
    puts_line
    diff = {
      "+": mapper.changes.map { _2[:after].split("\n").count }.sum,
      "-": mapper.changes.map { _2[:before].split("\n").count }.sum,
    }
    log "saving #{answers.count} files changed: #{diff[:"+"]} insertions(+), #{diff[:"-"]} deletions(-)"

    answers.each do |fname|
      answer = mapper.changes[fname]
      if answer[:after] == ""
        FileShell.remove fname, log_level: :higher
      else
        FileShell.write_text fname, answer[:after], log_level: :higher
      end
    end
  end

  section :mapping

  def generate(*args, &block)
    args = args.flatten
    cmd_env = Command.panel.forge ["generate", *args]
    cmd_env[:command] = SimpleCommand.new.tap do |cmd|
      cmd.instance_variable_set :@menv, cmd_env
      cmd.before
    end

    gen_env = panel.forge cmd_env
    gen_env[:simple_mapper] = mapper
    panel.forge_shortcut gen_env
    panel.find gen_env
    panel.find_shortcut gen_env
    panel.forward gen_env
  end

  def mapper() = env[:simple_mapper] ||= Mapper.new(self)

  class Mapper
    attr_reader :changes

    def log(*args, **kwargs)
      kwargs[:method_name] = 'map'
      @gen.log(*args, **kwargs)
    end

    def initialize(generator)
      @gen = generator
      log "#{self.class.last_namespace}.#{__method__}"
      @changes = {}
    end

    def get(fname)
      changes[fname]
    end

    def read_before(fname)
      cache fname
      changes[fname][:before]
    end

    def read_after(fname)
      cache fname
      changes[fname][:after]
    end

    def write_after(fname, text)
      log "#{self.class.last_namespace}.#{__method__} #{fname.to_s.sub App.root.to_s, "."}, #{text.size} bytes"
      cache fname
      changes[fname][:after] = text
    end

    def delete_after(fname)
      log "#{self.class.last_namespace}.#{__method__} #{fname.to_s.sub App.root.to_s, "."}"
      cache fname
      changes[fname][:after] = ""
    end

    private

    def cache(fname)
      raise "fname must be a Pathname" unless fname.is_a? Pathname
      return true if changes.key? fname
      
      s = ""
      s = DevSystem::FileShell.read_text(fname) if DevSystem::FileShell.exist? fname
      changes[fname] = {before: s, after: s}

      true
    end
    
  end

  section :files

  def create_file name, template, format
    contents = render! template, format: format
    create_file_contents name, contents
  end

  def create_file_contents name, contents
    update_file name, contents
  end

  def read_file name
    path = App.root.join name
    mapper.read_after path
  end

  def update_file name, contents
    path = App.root.join name
    mapper.write_after path, contents
  end

  def delete_file name
    path = App.root.join name
    mapper.delete_after path
  end

  def copy_examples controller
    puts
    log controller.to_s
    singular = controller.singular
    sys = controller.system.token
    
    [
      Lizarb.gem_dir,
      Lizarb.app_dir,
    ].uniq.each do |dir|
      FileShell.directory? "#{dir}/examples/#{singular}" or next
      copy_files "#{dir}/examples/#{singular}/app/#{sys}", "#{App.directory}/#{sys}"
    end
  end

  #

  def copy_files from_folder, to_folder
    from_pattern = "#{from_folder}/**/*"
    log "from_pattern = #{from_pattern}"

    from_files = Dir[from_pattern]
    log "from_files"
    log_array from_files
    puts

    from_files.each do |source|
      next if File.directory? source

      target = source.sub(from_folder, to_folder)
      copy_file source, target
    end
  end

  def copy_file source, target
    path = App.root.join target
    text = FileShell.read_text source
    mapper.write_after path, text
  end

  section :arg_views

  def arg_views_none?() = arg_views == 'none'

  def arg_views_eof?() = arg_views == 'eof'

  def arg_views_adjacent?() = arg_views == 'adjacent'

  def arg_views_nested?() = arg_views == 'nested'

  def self.set_default_views(views) = before_instance_call(:set_default_views, views)

  def set_default_views(views) = command.set_default_string(:views, views)
    
  def valid_views() = @valid_views ||=  %w[none eof adjacent nested]

  def arg_views() = @arg_views ||= command.simple_string(:views)

  set_input_string :views do |default|
    title = "Choose views"
    valid_views = env[:generator].valid_views
    index_base_1 = valid_views.index(default) + 1 rescue 1
    InputShell.select title, valid_views, default: index_base_1
  end
  
  set_default_views "none"
  
  section :unit

  def add_unit(unit, class_names, unit_path)
    raise "unit_path cannot be empty" if unit_path.nil?
    @current_unit = unit
    @class_names = class_names
    @class_name = class_names[0]
    unit.sections.each do |section|
      @current_section = section
      section[:content] = render! section[:render_key], format: :rb
    end
    unit.views.each do |view|
      view[:content] = render! view[:render_key], format: view[:render_format]
    end

    new_lines = render! :unit, format: :rb
    if arg_views_eof? && unit.views.any?
      new_lines << "\n__END__\n\n"
      unit.views.each do |view|
        new_lines << "# view #{view[:name]}.#{view[:format]}.erb\n#{view[:content]}"
      end
    end
    mapper.write_after unit_path, new_lines
  end

  def add_view(unit, view, view_path)
    raise "view_path cannot be empty" if view_path.nil?
    view[:content] = render! view[:render_key], format: view[:render_format]

    new_content = view[:content].dup
    new_content.prepend "# view #{view[:name]}.#{view[:format]}.erb\n" if arg_views_adjacent?
    mapper.write_after view_path, new_content
  end

  class UnitHelper
    def section section = {}
      sections << section
      section[:name] or raise "name is required"
      section[:render_key] ||= section[:name]
    end

    def view view = {}
      views << view
      view[:render_key] or raise "render_key is required"
      view[:render_format] ||= view[:format]
      view[:render_format] or raise "render_format is required"
    end

    def sections
      @sections ||= []
    end

    def views
      @views ||= []
    end
  end

  def remove_units(units)
    units.each do |unit|
      unit_path_radical = unit.source_location_radical
      unit_path = "#{unit_path_radical}.rb"

      mapper.delete_after Pathname unit_path
      views = Dir["#{unit_path_radical}*/**/*"]
      views.each do |fname|
        mapper.delete_after Pathname fname
      end
    end
  end

  def pick_many_units(units)
    options = units.map do |unit|
      [
        "#{TypographyShell.color_class unit}",
        unit
      ]
    end.to_h
    selected = units.count == 1 ? :all : :none
    InputShell.multi_select "Pick Multiple Controllers", options, selected: selected
  end

  def app_shell() = @app_shell ||= AppShell.new

  def puts_line() =  puts "-" * 120

end
