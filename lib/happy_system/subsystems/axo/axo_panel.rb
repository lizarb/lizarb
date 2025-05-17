class HappySystem::AxoPanel < Liza::Panel

  def call(menv)
    log :high, "menv.count is #{menv.count}"
    menv[:args] = Array menv[:args][1..-1]
    menv[:axo].call menv
  end

end
