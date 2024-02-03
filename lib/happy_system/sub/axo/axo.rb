class HappySystem::Axo < Liza::Controller

  def self.call(env)
    log :high, "env.count is #{env.count}"
    new.tap { _1.env = env }.call(env[:args])
  end

  attr_accessor :env

end
