class DevSystem::GenerateCommand < DevSystem::Command

  def call args
    log "args = #{args}" if DevBox[:generator].get :log_details

    DevBox[:generator].call args
  end

  def self.format args
    log "args = #{args.inspect}" if DevBox[:generator].get :log_details

    raise ArgumentError, "args[0] must be present" unless args[0]

    format = args[0].to_sym
    raise ArgumentError, "format #{format.inspect} not found" unless DevBox[:generator].format? format

    fname = args[1]
    raise ArgumentError, "fname must be present" unless FileShell.file? fname

    content = TextShell.read fname

    fname = fname.sub /\.html$/, ".html.html"
    content = DevBox.format format, content

    TextShell.write fname, content
  end

end
