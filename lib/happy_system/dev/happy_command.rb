class HappySystem::HappyCommand < Liza::Command

  def self.call args
    if args[0] == "axo"
      Axo.call args[1..-1]
    else
      log "unrecognized game: #{args[0]}. Try `liza happy axo` instead"
    end
  end

end
