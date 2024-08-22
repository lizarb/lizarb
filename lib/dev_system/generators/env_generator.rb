class DevSystem::EnvGenerator < DevSystem::BaseGenerator

  # liza g env
  def call_default
    if app_env_exists?
      log stick :light_red, "env files already exist"
    else
      write_env_files
    end

    puts
    log "done"
  end

  private

  def app_env_exists?
    FileShell.exist? "app.env"
  end

  def write_env_files
    # app
    @env_name = nil
    content = render :env, format: :env
    puts "-" * 80
    puts stick :light_green, content
    TextShell.write "app.env",      content

    # app.code
    @env_name = :code
    content = render :env, format: :env
    puts "-" * 80
    puts stick :light_green, content
    TextShell.write "app.code.env", content

    # app.demo
    @env_name = :demo
    content = render :env, format: :env
    puts "-" * 80
    puts stick :light_green, content
    TextShell.write "app.demo.env", content
  end

end

__END__

# view env.env.erb
#
<%= render :"#{@env_name || :blank}", format: :env -%>
#

# app variables



<% App.systems.keys.each do |k| -%>
# <%= k %> variables



<% end -%>

# view code.env.erb
# ENV VARIABLES FOR MODE=code (default)
#
# MODE=code lizarb commands
# lizarb commands

# view demo.env.erb
# ENV VARIABLES FOR MODE=demo
#
# MODE=demo lizarb commands

# view blank.env.erb
# ENV VARIABLES FOR ALL MODES
#
# MODE=code lizarb commands
# MODE=demo lizarb commands
# lizarb commands
