class DevSystem::Shell < Liza::Controller

  # Returns all descendants of Shell
  def self.all
    @all ||= AppShell.classes.select { _1 <= self }
  end

  # Check if the current platform is Windows
  def self.windows?
    @windows || Gem.win_platform?
  end

  # Check if the current platform is Unix or Unix-like
  def self.unix?
    @unix || !windows?
  end

  # Check if the current platform is Linux
  def self.linux?
    @linux || (unix? && RbConfig::CONFIG['host_os'].include?("linux"))
  end

  # Check if the current platform is Mac OS
  def self.mac?
    @mac || (unix? && RbConfig::CONFIG['host_os'].include?("darwin"))
  end

  # Return the current operating system as a symbol
  def self.os
    return :windows if windows?
    return :linux   if linux?
    return :mac     if mac?
    :unix
  end

  # Return the current Ruby engine as a symbol
  def self.engine
    return :jruby if jruby?
    return :cruby if cruby?
    :unknown
  end

  # Check if the current Ruby engine is JRuby
  def self.jruby?
    @jruby || RUBY_ENGINE == "jruby"
  end

  # Check if the current Ruby engine is MRI
  def self.cruby?
    @ruby || RUBY_ENGINE == "ruby"
  end

  # Return the current Ruby version as a Gem::Version
  def self.ruby_version
    Lizarb.ruby_version
  end

end
