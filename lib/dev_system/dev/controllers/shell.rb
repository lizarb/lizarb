class DevSystem::Shell < Liza::Controller

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

end
