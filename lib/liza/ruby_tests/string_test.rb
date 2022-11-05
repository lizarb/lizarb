class Liza::StringTest < Liza::RubyTest
  
  test :subject_class do
    assert subject_class == String
  end

  test :initializers do
    s0 = String.new
    s1 = ''
    s2 = ""
    
    assert s0.class == String
    assert s1.class == String
    assert s2.class == String
  end
  
end
