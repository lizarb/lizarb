class DevSystem::BaseCommand < DevSystem::Command

  #

  def self.call(env)
    super
    command = env[:command] = new
    command.call env
  end

  #

  attr_reader :env

  def call(env)
    log :higher, "env.count is #{env.count}"
    @env = env
    before
    method_name = "call_#{action_name}"
    if respond_to? method_name
      public_send method_name
      after
      return true
    end

    log "method not found: #{method_name.inspect}"
    raise NoMethodError, "method not found: #{method_name.inspect}"
  end

  def before
    # placebolder
  end

  def after
    # placebolder
  end

  #

  def self.get_command_signatures
    signatures = []
    ancestors_until(BaseCommand).each do |c|
      signatures +=
        c.instance_methods_defined.select do |name|
          name.start_with? "call_"
        end.map do |name|
          {
            name: ( name.to_s.sub("call_", "").sub("default", "") ),
            description: "# no description",
          }
        end
    end
    signatures.uniq { _1[:name] }
  end

  #

  def args
    env[:args]
  end

  def action_name() = env[:command_action]

  def self.typo() = TypographyShell

  def typo() = TypographyShell

end
