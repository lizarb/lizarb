class WebSystem::FirstMiddleRack < WebSystem::MiddleRack

  def call env
    puts unless $coding
    super
  end

end
