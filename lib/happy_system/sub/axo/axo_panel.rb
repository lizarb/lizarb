class HappySystem::AxoPanel < Liza::Panel

  def call(env)
    log :high, "env.count is #{env.count}"
    env[:args] = Array env[:args][1..-1]
    env[:axo].call env
  end

end
