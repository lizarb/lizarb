class DevSystem::LogCommand < DevSystem::SimpleCommand
  
  # liza log

  def call_default
    print_log_handlers
    print_log_levels
  end

  def print_log_handlers
    puts stick " LOG HANDLERS ".center(80, "-"), :b, system.color
    puts
    DevBox[:log].handlers.each do |key, log_class|
      log "handler :#{key.to_s.ljust_blanks 25} => #{log_class}"
    end
    puts
  end

  def print_log_levels
    puts stick " LOG LEVELS ".center(80, "-"), :b, system.color
    puts
    log :highest, ":highest #{ log_levels[ :highest ] } >= #{ log_level }"
    log :higher,  ":higher  #{ log_levels[ :higher  ] } >= #{ log_level }"
    log :high,    ":high    #{ log_levels[ :high    ] } >= #{ log_level }"
    log :normal,  ":normal  #{ log_levels[ :normal  ] } >= #{ log_level }"
    log :low,     ":low     #{ log_levels[ :low     ] } >= #{ log_level }"
    log :lower,   ":lower   #{ log_levels[ :lower   ] } >= #{ log_level }"
    log :lowest,  ":lowest  #{ log_levels[ :lowest  ] } >= #{ log_level }"
    puts
    puts "-".center(80, "-")
    puts
    puts ":highest " if log_level? :highest
    puts ":higher  " if log_level? :higher
    puts ":high    " if log_level? :high
    puts ":normal  " if log_level? :normal
    puts ":low     " if log_level? :low
    puts ":lower   " if log_level? :lower
    puts ":lowest  " if log_level? :lowest
    puts
    puts "-".center(80, "-")
    puts
    puts ":highest " if log? :highest
    puts ":higher  " if log? :higher
    puts ":high    " if log? :high
    puts ":normal  " if log? :normal
    puts ":low     " if log? :low
    puts ":lower   " if log? :lower
    puts ":lowest  " if log? :lowest
    puts
  end

end
