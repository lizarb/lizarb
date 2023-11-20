class ColorCommand < DevSystem::SimpleCommand

  def call_default
    log "args are #{env[:args].inspect}"
    
    color = simple_color :color

    string = "Ruby was created in 1993 by the Japanese Computer Scientist Yukihiro Matsumoto with simplicity in mind"
    
    puts
    log stick string, color
    log stick string, color, :b
    log stick string, color, :b, :u
    log stick string, color, :b, :u, :i
    log stick string, color, :u, :i
    log stick string, color, :i
    log stick string, color, :i, :b
    
    puts
    log stick string, :black, color
    log stick string, :black, color, :b
    log stick string, :black, color, :b, :u
    log stick string, :black, color, :b, :u, :i
    log stick string, :black, color, :u, :i
    log stick string, :black, color, :i
    log stick string, :black, color, :i, :b
  end

end
