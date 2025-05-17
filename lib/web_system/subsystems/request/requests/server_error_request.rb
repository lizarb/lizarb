class WebSystem::ServerErrorRequest < WebSystem::Request

  def self.call(menv)
    super
    status = 500

    headers = {
      "Framework" => "Liza #{Lizarb::VERSION}"
    }

    e = menv["LIZA_ERROR"]
    body = ""
    body << "<html>"
    body << "<head>"
    body << "<title>Server Error #{status}</title>"
    body << "</head>"
    body << "<body>"
    body << "<h1>Server Error #{status}</h1>"
    body << "<h2>#{e.class} - #{e.message}</h2>"

    body << "<ol>"
    e.backtrace.each do |line|
      body << "<li>#{line}</li>\n"
    end
    body << "</ol>"
    
    body << "\n\n" << e.backtrace.join("\n")
    body << "\n\n" << e.inspect
    body << "\n\n" << e.class.to_s

    [status, headers, [body]]
  end

end
