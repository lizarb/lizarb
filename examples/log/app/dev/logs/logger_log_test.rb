class LoggerLogTest < DevSystem::LogTest

  test :subject_class do
    assert subject_class == LoggerLog
  end
  
  test_sections(
    :default=>{
      :constants=>[],
      :class_methods=>[:call],
      :instance_methods=>[]
    }
  )

end
