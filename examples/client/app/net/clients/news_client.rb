class NewsClient < NetSystem::Client

  #
  
  def self.ruby_news
    new.call "https://www.ruby-lang.org/en/feeds/news.rss"
  end

  def self.ruby_weekly
    new.call "https://cprss.s3.amazonaws.com/rubyweekly.com.xml"
  end

  #

  def call url
    t = Time.now
    body = http_get url
    hash = xml_to_hash body
    log "rss channel title: #{ hash.dig :rss, :channel, :title }"
    hash
  ensure
    log "#{time_diff t}s to request #{url}"
    hash
  end

  def http_get url
    require "net/http"
    request_uri = URI(url)
    log "GET #{request_uri}"
    Net::HTTP.get(request_uri)
  end

  def xml_to_hash string
    # https://github.com/savonrb/nori
    gem "nori"
    gem "rexml"
    require "nori"
    require "rexml"
    Nori.new(:parser => :rexml).parse string
  end
  
end
