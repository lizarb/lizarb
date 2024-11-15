class HappySystem::AxoCommand < DevSystem::SimpleCommand
  
  #

  def call_default
    find!

    env[:axo] = @axo
    HappyBox[:axo].call(env)

    log "done at #{Time.now}"
  end

  def find!
    @name = simple_args[0]

    if @name
      @axo = Liza.const "#{@name}_axo"
      return
    end

    @axo = pick_axo
    @name = @axo.last_namespace.snakecase
  ensure
    log :low, "@name = #{@name}"
    log :low, "@axo = #{@axo}"
  end

  def pick_axo
    Lizarb.eager_load!
    axos = Axo.descendants
    options = axos.sort_by(&:last_namespace).map do |axo|
      [
        "#{axo.last_namespace.snakecase.ljust 30} - #{axo} - #{(axo.get :description) || "No description."}",
        axo
      ]
    end.to_h
    TtyInputCommand.pick_one "Pick an Axolotl ASCII Animation to run", options
  end

end
