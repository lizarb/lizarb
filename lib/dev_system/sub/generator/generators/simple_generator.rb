class DevSystem::SimpleGenerator < DevSystem::BaseGenerator

  #

  def inform
    log :highest, "informing #{changes.count} changes"

    changes.each do |change|
      puts_line

      action = "updating"
      action = "creating" if change.old_lines.empty?
      # action = "deleting" if change.new_lines.empty? # not implemented

      diff = {
        "+": (change.new_lines - change.old_lines).count,
        "-": (change.old_lines - change.new_lines).count,
      }

      bit = diff.map { "#{_1}#{_2}" }.join(" ")
      relative = Pathname(change.path).relative_path_from(App.root)
      string = "#{action.ljust 8} | #{"#{bit}".rjust 8} lines | #{relative}"
      log :highest, string

      if log_level? :high
        puts relative
        LineDiffShell.log_diff(change.old_lines, change.new_lines) if diff.values.sum.positive?
      end
    end 
  end

  #

  def save
    puts_line
    diff = {
      "+": changes.map { _1.new_lines.count }.sum,
      "-": changes.map { _1.old_lines.count }.sum,
    }
    log "saving #{changes.count} files changed: #{diff[:"+"]} insertions(+), #{diff[:"-"]} deletions(-)"

    if env[:args].include? "+confirm"
      answers = changes
    else
      choices = changes.map { |i| [i.relative_path.to_s, i] }.to_h
      answers = box.pick_many "Approve all changes?", choices
    end

    #

    puts_line
    diff = {
      "+": answers.map { _1.new_lines.count }.sum,
      "-": answers.map { _1.old_lines.count }.sum,
    }
    log "saving #{answers.count} files changed: #{diff[:"+"]} insertions(+), #{diff[:"-"]} deletions(-)"

    answers.each do |change|
      if change.old_lines == change.new_lines
        log "skipping #{change.path}"
      else
        log "writing #{change.path}"
        TextShell.write change.path, change.new_lines.join(""), log_level: :lower
      end
    end
  end

  # changes

  def changes
    @changes ||= []
  end

  def last_change
    @last_change
  end

  def add_change change
    log :lower, "#{change.class}"
    @last_change = change
    changes << change
    self
  end

  # create_file

  def create_file name, template, format
    path = App.root.join name
    file = TextFileShell.new path

    new_lines = render! template, format: format
    file.new_lines = new_lines.strip.split("\n").map { "#{_1}\n" }

    add_change file
  end

  # create_unit
  
  def create_unit unit, class_names, path, template = :unit
    unit.sections.each do |section|
      @current_section = section
      section[:content] = render! section[:name], format: :rb
    end
    unit.views.each do |view|
      @current_view = view
      view[:content] = render! view[:name], format: view[:format]
    end
    @sections = unit.sections
    @views = unit.views
    @class_names = class_names

    file = TextFileShell.new path
    file.new_lines = render! template, format: :rb
    file.new_lines = file.new_lines.split("\n").map { "#{_1}\n" }
    add_change file
  end

  # helper classes

  class UnitHelper
    def section name, section = {}
      sections << section
      section[:name] = name
    end

    def view name, view = {}
      views << view
      view[:name] = name
      view[:key] ||= name
      view[:format] ||= :rb
    end

    def sections
      @sections ||= []
    end

    def views
      @views ||= []
    end
  end

  #

  def copy_examples controller
    puts
    log controller.to_s
    singular = controller.singular
    plural = controller.plural
    sys = controller.system.token
    
    [
      Lizarb::GEM_DIR,
      Lizarb::APP_DIR,
    ].uniq.each do |dir|
      FileShell.directory? "#{dir}/examples/#{singular}" or next
      copy_files "#{dir}/examples/#{singular}/app/#{sys}/#{plural}", "#{App.folder}/#{sys}/#{plural}"
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
    file = TextFileShell.new path
    file.new_lines = TextShell.read_lines source
    add_change file
  end

  #

  def name!
    @name = command.simple_arg_ask_snakecase 0, "Name your new #{@controller_class.last_namespace}:"
    log "@name = #{@name.inspect}"
  end

  #

  def place!
    places = ControllerShell.places_for(@controller_class)
    @place = places.keys[0] if places.count == 1
    @place ||= command.simple_controller_placement :place, places
    @path = places[@place]
    log "@place, @path = #{@place.inspect}, #{@path.inspect}"
  end

  # create_controller

  def create_controller(name, controller, place, path, ancestor: controller, &block)
    unit, test = UnitHelper.new, UnitHelper.new

    @class_name = "#{name.camelize}#{controller.last_namespace}"
    @class_name = "#{place.split("/").first.camelize}System::#{@class_name}" unless place == "app"

    unit_classes = [@class_name, ancestor.to_s]
    test_classes = unit_classes.map { "#{_1}Test" }

    unit_path = App.root.join(path).join("#{name}_#{controller.division.singular}.rb")
    test_path = App.root.join(path).join("#{name}_#{controller.division.singular}_test.rb")

    # decorate

    yield unit, test

    # create

    create_unit unit, unit_classes, unit_path
    create_unit test, test_classes, test_path

    log "done"
  end

  # helper methods

  def puts_line
    puts "-" * 120
  end

end

__END__

# view unit.rb.erb
class <%= @class_names[0] %> < <%= @class_names[1] %>
  <% @sections.each do |section| %>
  # <%= section[:caption] %>
<%= section[:content] -%>
  <% end -%>

end
<% if @views.any? -%>

<%= "__END__" %>

<% @views.each do |view| -%>
<%= "#" -%> view <%= view[:key] %>.<%= view[:format] %>.erb

<%= view[:content] -%>

<% end -%>
<% end -%>
