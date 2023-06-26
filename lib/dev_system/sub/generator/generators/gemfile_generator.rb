class DevSystem::GemfileGenerator < DevSystem::Generator

  def self.call args
    log "args = #{args.inspect}"

    new.call args
  end

  def call args
    log "args = #{args.inspect}"
    @name = args.first || "Gemfile"

    if gemfile_exists?
      puts_content_diff
      if agrees_to_overwrite?
        TextShell.write @name, new_content
      end
    else
      puts_new_content
      TextShell.write @name, new_content
    end

    puts
    log "done"
  end

  private

  def gemfile_exists?
    FileShell.exist? @name
  end

  def puts_content_diff
    puts
    puts "-" * 80
    puts old_content.red
    puts "-" * 80
    puts new_content.green
    puts "-" * 80
    puts
  end

  def puts_new_content
    puts
    puts "-" * 80
    puts new_content.green
    puts "-" * 80
    puts
  end

  def prompt
    @prompt ||= TTY::Prompt.new symbols: {marker: ">", radio_on: "x", radio_off: " "}
  end

  def old_content
    TextShell.read @name
  end

  def new_content
    @new_content ||= render_controller "inline.txt"
  end

  def agrees_to_overwrite?
    log "#{@name} already exists. Do you want to overwrite it?"
    answer = prompt.select("Overwrite?", ["Yes", "No"], filter: true, show_help: :always)
    bool = answer == "Yes"

    if bool
      log "Overwriting #{@name}"
    else
      log "Not overwriting #{@name}"
    end

    bool
  end

end

__END__

# frozen_string_literal: true

source "https://rubygems.org"

group :default do
  gem "lizarb", "~> <%= Lizarb::VERSION %>"
  # gem "lizarb", github: "rubyonrails-brasil/lizarb"
end

group :dev do
  # gems you only want to load if DevSystem is loaded

  # Generator gems
  gem "htmlbeautifier", "~> 1.4"
  gem "commonmarker", "~> 0.23.9"
  gem "haml", "~> 6.1"
  gem "sassc", "~> 2.4"
  gem "coffee-script", "~> 2.4"
  
  # Terminal gems
  gem "pry", "~> 0.14.1"
end
