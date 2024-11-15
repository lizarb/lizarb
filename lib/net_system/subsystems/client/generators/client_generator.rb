class NetSystem::ClientGenerator < DevSystem::ControllerGenerator
  
  section :actions
  
  # liza g client name place=app

  def call_default
    set_default_super ""
    
    create_controller do |unit, test|
      unit.section name: :controller
      test.section name: :test
    end
  end
  
  # liza g client:examples
  
  def call_examples
    copy_examples Client
  end
  
end
