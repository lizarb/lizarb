class ArtSystem::DeepseekCommand < DevSystem::SimpleCommand


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

  # liza deepseek s1 s2 s3 +b1 +b2 -b3 -b4 k1=v1 k2=v2
  def call_default
    log stick :b, system.color, "I just think Ruby is the Best for coding!"
    call_chat

  rescue => e
    log "rescued from (#{e.class}) #{e.message}"
    binding.irb
  end

  # liza deepseek:chat s1 s2 s3 +b1 +b2 -b3 -b4 k1=v1 k2=v2
  def call_chat
    log stick :b, system.color, "I just think Ruby is the Best for coding!"

    set_default_arg(0, "Hello!")
    content = simple_args.join(" ")

    set_default_string :model, "deepseek-chat"
    model = simple_string(:model)

    shell = DeepseekShell.new
    client = shell.client
    response = client.chat(
      parameters: {
        model: model,
        messages: [{ role: "user", content: content}],
        temperature: 0.7
      }
    )
    log response
    puts response.dig("choices", 0, "message", "content")

  rescue => e
    log "#{e.class}: #{e.message}"
    binding.irb
  end

end
