class DevSystem::StickLogLogTest < DevSystem::LogTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::StickLogLog, subject_class
  end

  test :call do
    prefix = "  "
    object = "ABC"
    expected = "ABC"
    call_subject_with prefix, object, expected

    object = Object
    expected = "Object"
    call_subject_with prefix, object, expected
    
    object = Object.new
    expected = "#<Object:0x"
    env = {object: object, prefix: prefix}
    subject_class.call(env)
    assert env[:object_parsed].start_with? expected
  end

end
