class HappySystem
  class HappyBox < Liza::Box
    has_panel :axo
    has_controller :axo

    # Set up your axo panel per the DSL in http://guides.lizarb.org/panels/axo.html
    axo do
      # set :log_level, ENV["happy.axo.log_level"]
    end

  end
end
