class DevSystem::StickLogTest < DevSystem::LogTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::StickLog, subject_class
  end

  test :subject_class, :new do
    s = subject_class.new "I LOVE RUBY"
    assert_equality s.class, subject_class
    assert_equality s.text, "I LOVE RUBY"
    assert_equality s.fore, [255, 255, 255]
    assert_equality s.back, nil
    assert_equality s.to_s, "\e[38;2;255;255;255mI LOVE RUBY\e[0m"
    
    s = subject_class.new "I LOVE RUBY", :bold, :italic, :underlined
    assert_equality s.class, subject_class
    assert_equality s.text, "I LOVE RUBY"
    assert_equality s.fore, [255, 255, 255]
    assert_equality s.back, nil
    assert_equality s.bold, true
    assert_equality s.italic, true
    assert_equality s.underlined, true
    assert_equality s.to_s, "\e[1m\e[3m\e[4m\e[38;2;255;255;255mI LOVE RUBY\e[0m"
    
    s = subject_class.new "I LOVE RUBY", :b, :i, :u
    assert_equality s.class, subject_class
    assert_equality s.text, "I LOVE RUBY"
    assert_equality s.fore, [255, 255, 255]
    assert_equality s.back, nil
    assert_equality s.bold, true
    assert_equality s.italic, true
    assert_equality s.underlined, true
    assert_equality s.to_s, "\e[1m\e[3m\e[4m\e[38;2;255;255;255mI LOVE RUBY\e[0m"
    
    s = subject_class.new "I LOVE RUBY", :b, :i, :u, :red
    assert_equality s.class, subject_class
    assert_equality s.text, "I LOVE RUBY"
    assert_equality s.fore, [204, 0, 0]
    assert_equality s.back, nil
    assert_equality s.to_s, "\e[1m\e[3m\e[4m\e[38;2;204;0;0mI LOVE RUBY\e[0m"
    
    s = subject_class.new "I LOVE RUBY", :b, :i, :u, :red, :white
    assert_equality s.class, subject_class
    assert_equality s.text, "I LOVE RUBY"
    assert_equality s.fore, [204, 0, 0]
    assert_equality s.back, [248, 248, 248]
    assert_equality s.to_s, "\e[1m\e[3m\e[4m\e[38;2;204;0;0m\e[48;2;248;248;248mI LOVE RUBY\e[0m"
    
    s = subject_class.new "I LOVE RUBY", :b, :i, :u, 0xff9900, :white
    assert_equality s.class, subject_class
    assert_equality s.text, "I LOVE RUBY"
    assert_equality s.fore, [255, 153, 0]
    assert_equality s.back, [248, 248, 248]
    assert_equality s.to_s, "\e[1m\e[3m\e[4m\e[38;2;255;153;0m\e[48;2;248;248;248mI LOVE RUBY\e[0m"
    
    s = subject_class.new "I LOVE RUBY", :b, :i, :u, "#ff9900", :white
    assert_equality s.class, subject_class
    assert_equality s.text, "I LOVE RUBY"
    assert_equality s.fore, [255, 153, 0]
    assert_equality s.back, [248, 248, 248]
    assert_equality s.to_s, "\e[1m\e[3m\e[4m\e[38;2;255;153;0m\e[48;2;248;248;248mI LOVE RUBY\e[0m"
    
    s = subject_class.new "I LOVE RUBY", :b, :i, :u, "ff9900", :white
    assert_equality s.class, subject_class
    assert_equality s.text, "I LOVE RUBY"
    assert_equality s.fore, [255, 153, 0]
    assert_equality s.back, [248, 248, 248]
    assert_equality s.to_s, "\e[1m\e[3m\e[4m\e[38;2;255;153;0m\e[48;2;248;248;248mI LOVE RUBY\e[0m"
  end

end
