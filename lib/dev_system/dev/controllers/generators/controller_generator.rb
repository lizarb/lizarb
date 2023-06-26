class DevSystem::ControllerGenerator < DevSystem::Generator

  def self.call args
    log "args = #{args.inspect}"
    new.generate_app_controller(*args)
  end

  def generate_app_controller system_name, controller_name, folder, name
    log "(#{system_name.inspect}, #{controller_name.inspect}, #{folder.inspect}, #{name.inspect})"

    @name = name
    @panels = []

    filename = "app/#{system_name}/#{folder}/#{name}_#{controller_name}.rb"
    content = render_controller "controller.rb"
    TextShell.write filename, content

    filename = "app/#{system_name}/#{folder}/#{name}_#{controller_name}_test.rb"
    content = render_controller "controller_test.rb"
    TextShell.write filename, content
  end

  #

  def self.install args
    log "args = #{args.inspect}"

    system_name = get(:system).name.snakecase.gsub "_system", ""
    controller_name = last_namespace.snakecase.gsub "_generator", ""

    new.instance_exec do
      log "#install_app_panel"

      @filename = "app/#{system_name}_box.rb"
      @system_name = system_name
      @controller_name = controller_name
      @panels = {}

      install_write_box unless FileShell.exist? @filename
      install_read_box
      install_insert_panel
      install_write_box
    end
  end

  # helper methods

  def install_write_box
    @content = render_controller "app_box.rb"
    TextShell.write @filename, "#{@content.strip}\n"
  end

  def install_read_box
    @content ||= TextShell.read @filename

    cursor = nil
    @content.split("\n").each do |line|
      md = line.match(/^  configure :(.*) do$/)
      if md
        cursor = md[1]
        @panels[cursor] = {lines: []}
      elsif line =~ /^  end$/
        cursor = nil
      else
        next unless cursor
        @panels[cursor][:lines] << line
      end
    end
  end

  def install_insert_panel
    lines = render_controller("install_insert_panel.rb").split("\n").reject(&:empty?)
    @panels[@controller_name] = {lines: lines}
    @panels = @panels.sort_by(&:first)
  end

end

__END__

# view app_box.rb.erb

class <%= @system_name.camelcase %>Box < Liza::<%= @system_name.camelcase %>Box

<% @panels.each do |key, panel| -%>
  configure :<%= key %> do
<% panel[:lines].each do |line| -%>
<%= line %>
<%   end -%>
  end

<% end -%>
end

# view install_insert_panel.rb.erb

    #
