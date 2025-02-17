class LoggerHandlerLogTest < DevSystem::HandlerLogTest

  test :subject_class do
    assert subject_class == LoggerHandlerLog
  end
  
  test_sections(
    :default=>{
      :constants=>[],
      :class_methods=>[:call],
      :instance_methods=>[]
    }
  )

end
