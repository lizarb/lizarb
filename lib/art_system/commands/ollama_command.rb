class ArtSystem::OllamaCommand < DevSystem::SimpleCommand

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

  # liza ollama s1 s2 s3 +b1 +b2 -b3 -b4 k1=v1 k2=v2
  def call_default
    log stick :b, cl.system.color, "I just think Ruby is the Best for coding!"

    call_chat
  end

  # liza ollama:chat s1 s2 s3 +b1 +b2 -b3 -b4 k1=v1 k2=v2
  def call_chat
    log stick :b, cl.system.color, "I just think Ruby is the Best for coding!"

    content = args.join(" ")
    content = "Hello!" if content.empty?
    log "content: #{ content }"

    # model = "llama3.3"
    # model = "deepseek"
    model = "tinyllama"
    messages = [{ role: "user", content: content}]
    temperature = 0.7

    shell = OllamaShell.new
    client = shell.client
    response = client.chat(
      parameters: {
        model:,
        messages:,
        temperature:,
      }
    )
    log response
    puts response.dig("choices", 0, "message", "content")

  rescue => e
    log "rescued from (#{e.class}) #{e.message}"

    log "consider running these commands"

    puts
    puts "docker ps"
    puts "docker exec -it CONTAINER_ID sh"
    puts "docker exec -it CONTAINER_ID ollama list"
    puts "docker exec -it CONTAINER_ID ollama pull tinyllama"
    puts "docker exec -it CONTAINER_ID ollama pull deepseek"
    puts

    binding.irb
  end

end
