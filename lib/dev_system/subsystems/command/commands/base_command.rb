class DevSystem::BaseCommand < DevSystem::Command

  #

  def self.call(menv)
    super
    command = menv[:command] = new
    command.call menv
  end

  #

  def call(menv)
    super

    if respond_to? action_method_name
      around
    else
      not_found
    end
  end

  def around
    log :high, "."
    before
    public_send action_method_name
    after
    log :high, "."
  rescue Exception => e
    raise unless defined? rescue_from
    rescue_from e
  end

  def before
    # placebolder
  end

  def after
    # placebolder
  end

  def not_found
    log stick :red, "Not found: #{action_name}, please define method '#{action_method_name}'"
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

  menv_reader :args

  def action_name() = menv[:command_action]

  def action_method_name() = "call_#{action_name}"

  def self.typo() = TypographyShell

  def typo() = TypographyShell

end
