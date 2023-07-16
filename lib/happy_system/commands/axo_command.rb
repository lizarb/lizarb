class HappySystem::AxoCommand < DevSystem::Command
  
  #

  # lizarb axo a b c
  # lizarb axo:call a b c
  def self.call(args)
    log "args = #{args.inspect}"

    new.call(args)
  end

  # lizarb axo#call a b c
  def call(args)
    log "@args = #{args.inspect}"
    @args = args

    Axo.call(args)

    log "done at #{Time.now}"
  end
end
