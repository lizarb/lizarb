class DevSystem::LogCommand < DevSystem::SimpleCommand
  
  # liza log

  def call_default
    log :higher, "args = #{args}"

    DevBox[:log].handlers.each do |key, log_class|
      log "handler #{key} maps to #{log_class}"
    end
  end
  
  # liza log:levels

  def call_levels
    puts
    log :highest, ":highest #{ log_levels[ :highest ] } >= #{ log_level }"
    log :higher,  ":higher  #{ log_levels[ :higher  ] } >= #{ log_level }"
    log :high,    ":high    #{ log_levels[ :high    ] } >= #{ log_level }"
    log :normal,  ":normal  #{ log_levels[ :normal  ] } >= #{ log_level }"
    log :low,     ":low     #{ log_levels[ :low     ] } >= #{ log_level }"
    log :lower,   ":lower   #{ log_levels[ :lower   ] } >= #{ log_level }"
    log :lowest,  ":lowest  #{ log_levels[ :lowest  ] } >= #{ log_level }"
  end

end
