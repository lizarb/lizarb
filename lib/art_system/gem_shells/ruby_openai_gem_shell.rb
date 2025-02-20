class ArtSystem::RubyOpenaiGemShell < DevSystem::GemShell
  require "openai"
  # gem install ruby-openai

  section :use_case_1

  def self.count_tokens(text)
    call({})
    c = OpenAI.rough_token_count(text)
    log "count_tokens: #{ c }"
    c
  end

  section :use_case_2

  def self.get_client(client_options = {})
    call({})
    client_options = get_default_configuration.merge(client_options)
    OpenAI::Client.new(client_options) do |faraday|
      faraday.response :logger, Logger.new($stdout), bodies: true if log? :high
    end
  end

  def self.get_default_configuration
    {
      log_errors: $coding,
      # uri_base: "https://api.openai.com/v1",
      # access_token: ENV.fetch("OPENAI_ACCESS_TOKEN")
    }
  end

end
