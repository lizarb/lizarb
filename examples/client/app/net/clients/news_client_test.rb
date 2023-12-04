class NewsClientTest < NetSystem::ClientTest
  
  # 

  test :subject_class, :subject do
    assert_equality NewsClient, subject_class
    assert_equality NewsClient, subject.class
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

end
