class DevSystem::PryCommand < DevSystem::SimpleCommand
  # https://github.com/pry/pry
  require "pry"

  # liza pry
  def call_default
    Pry.start
  end

end
