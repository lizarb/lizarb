class DevSystem::SimplerCommand < DevSystem::BaseCommand

  section :filters

  def before
    before_given
  end

  def after
    # must be defined here
  end

  section :given

  def given_args = env[:given_args]

  def given_strings = env[:given_strings]

  def given_booleans = env[:given_booleans]

  private

  def before_given
    given_strings  = args.select { |arg| arg.include? "=" }
    given_booleans = args.select { |arg| ["+", "-"].any? { arg.start_with? _1 }  }

    env[:given_args] = args - given_strings - given_booleans
    env[:given_strings] = given_strings.map { |arg| arg.split "=" }.map { |k,v| [k.to_sym, v] }.to_h
    env[:given_booleans] = given_booleans.map { |arg| [arg[1..-1], arg[0]=="+"] }.map { |k,v| [k.to_sym, v] }.to_h
  end

end
