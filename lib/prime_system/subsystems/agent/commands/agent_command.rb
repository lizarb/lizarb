class PrimeSystem::AgentCommand < DevSystem::SimpleCommand

  section :filters

  def before
    @t = Time.now
    super
    log stick :b, cl.system.color, "params #{ params }"
  end
  
  def after
    super
    log "#{ time_diff @t }s | done"
  end
  section :actions

  # liza agent s1 s2 s3 +b1 +b2 -b3 -b4 k1=v1 k2=v2
  def call_default
    color = :ember
    log stick :b, color, "I just think Ruby is the Best for coding!"
    sleep 0.2
    sleep 0.3
    sleep 0.1

  rescue => e
    log "rescued from (#{e.class}) #{e.message}"
    binding.irb
  end

end
