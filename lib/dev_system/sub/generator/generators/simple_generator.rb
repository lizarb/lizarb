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

    choices = changes.map { |i| [i.relative_path.to_s, i] }.to_h
    answers = box.pick_many "Approve all changes?", choices

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

  #

  def puts_line
    puts "-" * 120
  end

end
