class ArtSystem::OpenaiShell < DevSystem::Shell

  attr_accessor :client

  def initialize(access_token: nil, uri_base: nil)
    access_token ||= ENV.fetch "OPENAI_ACCESS_TOKEN"
    uri_base ||= ENV["OPENAI_URI_BASE"]
    client_options = {access_token:, uri_base:}

    self.client = RubyOpenaiGemShell.get_client(client_options)
  end

end
