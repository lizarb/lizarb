class DevSystem::SoftShell < DevSystem::Shell
  division!

  def self.programs
    @programs ||= {}
  end

  def self.program(
    name,
    path: nil,
    asdf: nil,
    aptitude: nil,
    pacman: nil,
    dnf: nil
  )
    if path
      any_of_the_others = [asdf, aptitude, pacman, dnf].compact.any?
      raise "path must be used alone" if any_of_the_others

      path = standardize_path(path)
      # TODO: check if path exists when needed
      # raise "not found: #{path}" unless FileShell.exist? path
    end

    @programs ||= {}
    @programs[name] = {name:, asdf:, path:, aptitude:, pacman:, dnf:}
  end

  def self.call(menv)
    super

    name = menv[:program] || programs.keys.first
    args = Array(menv[:program_args]).join(" ")
    if name.is_a? Symbol
      program = programs[name]
    else
      raise "program path not found: #{name}" unless File.exist? name
      program = {path: name}
    end
    raise "program not registered: #{name}" unless program
    path = program.yield_self { _1[:path] || _1[:name] }
    cmd = "#{path} #{args}"
    log "program: #{cmd}"

    bool = sh cmd
    menv[:program_result] = bool

    menv
  end

  def self.call_program(key, args=[])
    menv = {program: key, program_args: args}

    call(menv)

    if menv[:program_result]
      log "#{key}: #{menv[:program_result]}"
    else
      log "#{key} had an error"
    end

    menv
  end

  def self.standardize_path(path)
    return path if %w[. /].include? path[0]
    App.root.join(path).to_s
  end

end
