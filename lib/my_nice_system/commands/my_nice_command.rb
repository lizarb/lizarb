class MyNiceSystem::MyNiceCommand < DevSystem::SimpleCommand


  section :filters

  def before
    super
    @t = Time.now
    log "simple_args     #{ simple_args }"
    log "simple_booleans #{ simple_booleans }"
    log "simple_strings  #{ simple_strings }"
  end
  
  def after
    super
    log "#{ time_diff @t }s | done"
  end

  section :actions

  # liza my_nice s1 s2 s3 +b1 +b2 -b3 -b4 k1=v1 k2=v2
  def call_default
    color = :lighter_chartreuse
    log stick :b, color, "I just think Ruby is the Best for coding!"
    sleep 0.2
    sleep 0.2
    sleep 0.1

  rescue => e
    log "rescued from (#{e.class}) #{e.message}"
    binding.irb
  end

end
