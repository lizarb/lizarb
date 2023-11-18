class NetSystem::ClientGenerator < DevSystem::SimpleGenerator
  
  # liza g client name place=app

  def call_default
    @controller_class = Client

    name!
    place!

    create_controller @name, @controller_class, @place, @path do |unit, test|
      unit.section :controller_section_1
      test.section :controller_test_section_1
    end
  end
  
end

__END__

# view controller_section_1.rb.erb

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
    log "#{t.diff}s to request #{url}"
    hash
  end

  #

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
    log "parsing using Nori and REXML"
    Nori.new(:parser => :rexml).parse string
  end

# view controller_test_section_1.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end

  test :subject_class, :ruby_news do
    hash = subject_class.ruby_news
    a = hash.dig("rss", "channel", "title")
    b = "Ruby News"
    assert_equality a, b
  end

  test :subject_class, :ruby_weekly do
    hash = subject_class.ruby_weekly
    a = hash.dig("rss", "channel", "title")
    b = "Ruby Weekly"
    assert_equality a, b
  end
