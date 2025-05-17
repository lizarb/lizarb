class HappySystem::Axo < Liza::Controller

  def self.call(menv)
    super
    log :high, "menv.count is #{menv.count}"
    new.tap { _1.menv = menv }.call(menv[:args])
  end

end
