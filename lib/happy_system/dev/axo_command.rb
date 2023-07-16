class HappySystem::AxoCommand < Liza::Command

  def self.call args
    Axo.call args
  end

end
