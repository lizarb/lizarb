class LogoRequest < WebSystem::SimpleRequest


  section :actions

  # GET /logo

  def call_index
    @headers["Content-Type"] = "image/svg+xml" if format == :svg
  end

end
