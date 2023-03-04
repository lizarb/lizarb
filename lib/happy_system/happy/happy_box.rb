class HappySystem::HappyBox < Liza::Box

  # Set up your axo panel per the DSL in http://guides.lizarb.org/panels/axo.html
  panel :axo do
    # set :log_level, ENV["happy.axo.log_level"]
  end

  has_controller :axo
end
