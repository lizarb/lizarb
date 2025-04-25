class PrimeSystem::CachedKrokiClient < NetSystem::HttpClient

  set :kroki_url, "https://kroki.io/"

  def self.request(type, code)
    url = get :kroki_url
    diagram_source = code
    output_format = "svg"
    url = "#{url}/#{type}"
    Kernel.require "json"
    body = JSON.generate({diagram_source:, output_format:})
    cached_post_json_body(url, body)
  end

  def self.request_puml(code)
    request("plantuml", code)
  end

  def self.cached_post_json_body(url, payload, headers = {})
    Kernel.require "digest/md5"
    cache_key = Digest::MD5.hexdigest(payload)

    fname = "tmp/#{App.mode}/#{system.token}/#{division.plural}/#{cache_key}.svg"
    is_cached = FileShell.exist? fname
    if is_cached
      ret = FileShell.read_text fname
    else
      cl = post_json(url, payload, headers)
      ret = cl.body
      FileShell.write_text fname, ret
    end

    ret
  end

end
