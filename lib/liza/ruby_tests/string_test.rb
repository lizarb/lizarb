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
  
  test :lpartition do
    todo "write examples"
  end
  
  test :rpartition do
    todo "write examples"
  end
  
  test :camelcase do
    assert ""     == "".camelcase
    assert "A"    == "a".camelcase
    assert "Ab"   == "ab".camelcase
    assert "AbC"  == "ab_c".camelcase
    assert "AbCd" == "ab_cd".camelcase
    assert "Ab"   == "ab_".camelcase
    assert "Cd"   == "_cd".camelcase
  end
  
  test :snakecase do
    assert ""      == "".snakecase
    assert "a"     == "A".snakecase
    assert "ab"    == "Ab".snakecase
    assert "ab_c"  == "AbC".snakecase
    assert "ab_cd" == "AbCd".snakecase
    assert "ab"    == "ab".snakecase
    assert "cd"    == "cd".snakecase
  end

  test :rjust_blanks do
    todo "write examples"
  end

  test :rjust_zeroes do
    todo "write examples"
  end

  test :ljust_blanks do
    todo "write examples"
  end

  test :ljust_zeroes do
    todo "write examples"
  end
  
end
