class WebSystem::FirstMiddleRack < WebSystem::MiddleRack

  def call(menv)
    puts unless $coding
    super
  end

end
