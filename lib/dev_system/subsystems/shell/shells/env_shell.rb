class DevSystem::EnvShell < DevSystem::Shell

  define_error :mandatory do |args|
    "Mandatory Environment Variable Not Found: #{args[0]}. Your .env files are: #{App.env_vars}"
  end

  def self.key?(key)
    ENV.key? key
  end

  def self.optional(key, default = nil)
    ENV[key] || default
  end

  def self.mandatory(key)
    ENV[key] or raise_error :mandatory, key, kaller: caller
  end

end
