class ArtSystem::OllamaShell < DevSystem::Shell

  attr_accessor :client

  def initialize(access_token: nil, uri_base: nil)
    uri_base ||= ENV.fetch "OLLAMA_URI_BASE"
    client_options = {access_token:, uri_base:}

    self.client = RubyOpenaiGemShell.get_client(client_options)
  end

end
