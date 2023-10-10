class StickCommand < Liza::Command
  
  # lizarb stick

  def self.call args
    log "args = #{args.inspect}"

    log stick :white, :ruby, :b, "I just think Ruby is the Best for coding!".center(97)

    puts

    ColorShell.colors.each do |k, v|
      log [
        stick(v, :darkest_black, :b,     "#{k} ".rjust(20)),
        stick(k, :darkest_black, :b,     "[#{v.map { _1.to_s.rjust(3) }.join(", ")}] "),
        stick(v, :darkest_black, :b, :i, "I just think"),
        stick(v, :darkest_black, " "),
        stick(v, :darkest_black, :b, :u, "Ruby is the"),
        stick(v, :darkest_black, " "),
        stick(v, :darkest_black,         "Best for coding"),
        stick(v, :darkest_black, " "),
        stick(v, :darkest_black, :b,     "#{k} ".ljust(20)),
      ]
    end

    puts

    ColorShell.colors.each do |k, v|
      log [
        stick(v, :lightest_white, :b,     "#{k} ".rjust(20)),
        stick(k, :lightest_white, :b,     "[#{v.map { _1.to_s.rjust(3) }.join(", ")}] "),
        stick(v, :lightest_white, :b, :i, "I just think"),
        stick(v, :lightest_white, " "),
        stick(v, :lightest_white, :b, :u, "Ruby is the"),
        stick(v, :lightest_white, " "),
        stick(v, :lightest_white,         "Best for coding"),
        stick(v, :lightest_white, " "),
        stick(v, :lightest_white, :b,     "#{k} ".ljust(20)),
      ]
    end

  end

  # lizarb stick:systems
  
  def self.systems args
    log "args = #{args.inspect}"

    
    log stick :white, :ruby, :b, "I just think Ruby is the Best for coding!".center(97)

    puts

    App.systems.each do |k, v|
      log [
        stick(v.color, :darkest_black, :b,     "#{v} ".rjust(20)),
        stick(v.color, :darkest_black, :b,     "[#{v.color.map { _1.to_s.rjust(3) }.join(", ")}] "),
        stick(v.color, :darkest_black, :b, :i, "I just think"),
        stick(v.color, :darkest_black, " "),
        stick(v.color, :darkest_black, :b, :u, "Ruby is the"),
        stick(v.color, :darkest_black, " "),
        stick(v.color, :darkest_black,         "Best for coding"),
        stick(v.color, :darkest_black, " "),
        stick(v.color, :darkest_black, :b,     "#{v} ".ljust(20)),
      ]
    end

    puts

    App.systems.each do |k, v|
      log [
        stick(v.color, :b,     "#{v} ".rjust(20)),
        stick(v.color, :b,     "[#{v.color.map { _1.to_s.rjust(3) }.join(", ")}] "),
        stick(v.color, :b, :i, "I just think"),
        stick(v.color, " "),
        stick(v.color, :b, :u, "Ruby is the"),
        stick(v.color, " "),
        stick(v.color,         "Best for coding"),
        stick(v.color, " "),
        stick(v.color, :b,     "#{v} ".ljust(20)),
      ]
    end

    puts

    App.systems.each do |k, v|
      log [
        stick(v.color, :lightest_white, :b,     "#{v} ".rjust(20)),
        stick(v.color, :lightest_white, :b,     "[#{v.color.map { _1.to_s.rjust(3) }.join(", ")}] "),
        stick(v.color, :lightest_white, :b, :i, "I just think"),
        stick(v.color, :lightest_white, " "),
        stick(v.color, :lightest_white, :b, :u, "Ruby is the"),
        stick(v.color, :lightest_white, " "),
        stick(v.color, :lightest_white,         "Best for coding"),
        stick(v.color, :lightest_white, " "),
        stick(v.color, :lightest_white, :b,     "#{v} ".ljust(20)),
      ]
    end

  end

end
