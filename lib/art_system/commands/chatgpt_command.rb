class ArtSystem::ChatgptCommand < DevSystem::SimpleCommand

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
    log "#{ Lizarb.time_diff @t }s | done"
  end

  section :actions

  # liza chatgpt s1 s2 s3 +b1 +b2 -b3 -b4 k1=v1 k2=v2
  def call_default
    log stick :b, cl.system.color, "I just think Ruby is the Best for coding!"

    call_chat
  end

  # liza chatgpt:chat s1 s2 s3 +b1 +b2 -b3 -b4 k1=v1 k2=v2
  def call_chat
    log stick :b, cl.system.color, "I just think Ruby is the Best for coding!"

    # log stick :red, :white, "Not implemented yet"
    set_default_arg(0, "Hello!")
    content = simple_args.join(" ")

    set_default_string :model, "gpt-4o"
    model = simple_string(:model)

    shell = OpenaiShell.new
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

  # liza chatgpt:image s1 s2 s3 +b1 +b2 -b3 -b4 k1=v1 k2=v2
  def call_image
    log stick :b, cl.system.color, "I just think Ruby is the Best for coding!"

    set_default_arg(0, "A green lizard sitting atop a big red ruby")
    prompt = simple_args.join(" ")

    n = 1
    size = '512x512'

    shell = OpenaiShell.new
    client = shell.client
    response = client.images.generate(
      parameters: {
        prompt:,
        n:,
        size:
      }
    )
    image_url = response['data'][0]['url']
    log "Image URL: #{image_url}"
    # Download and save the image from image_url
    `wget "#{image_url}" -O chatgpt_image_#{@t.to_i}..png`

  rescue => e
    log "#{e.class}: #{e.message}"
    binding.irb
  end

  # liza chatgpt:audio s1 s2 s3 +b1 +b2 -b3 -b4 k1=v1 k2=v2
  def call_audio
    log stick :b, cl.system.color, "I just think Ruby is the Best for coding!"

    log stick :red, :white, "Not implemented yet"
  end

end
