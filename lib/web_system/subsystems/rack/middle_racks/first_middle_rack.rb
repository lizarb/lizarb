class WebSystem::FirstMiddleRack < WebSystem::MiddleRack

  def call(menv)
    puts unless App.development?
    super
  end

end
