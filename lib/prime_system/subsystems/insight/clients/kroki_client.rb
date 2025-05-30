class PrimeSystem::KrokiClient < NetSystem::Client
  require "json"
  require "digest/md5"

  set :kroki_url, "https://kroki.io/"

  def self.request(type, code, options={})
    call({})
    url = options[:kroki_url] || get(:kroki_url)
    url = "#{url}/#{type}"
    diagram_source = code
    output_format = "svg"
    body = JSON.generate({diagram_source:, output_format:})
    ret = post(url, body)
    if ret.start_with? "Error"
      log ret
      code.split("\n").map.with_index do |line, index|
        log "#{index.to_s.rjust_zeroes 3}: #{line}"
      end
      ret += "<br><br>\n\n#{ code.split("\n").map.with_index{ "#{ _2.to_s.rjust_zeroes 3 }: #{ _1 }<br>\n" }.join("") }"
    end
    ret
  end

  def self.request_puml(code, options={})
    request("plantuml", code, options)
  end

  def self.post(url, payload, headers = {})
    cache_key = Digest::MD5.hexdigest(payload)

    fname = "tmp/#{App.mode}/#{system.token}/#{self.plural}/#{cache_key}.svg"
    is_cached = FileShell.exist? fname, log_level: :high
    if is_cached
      log stick :green, :b, "Response will be read from cache #{fname}"
      ret = FileShell.read_text fname, log_level: :high
    else
      cl = HttpClient.post_json(url, payload, headers)
      ret = cl.body
      if cl.response_code == 200
        log stick :green, :b, "Response #{cl.response_code} will be cached in #{fname}"
        FileShell.write_text fname, ret, log_level: :high
      end
    end

    ret
  end

end
