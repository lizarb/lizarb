class HappySystem::AxoGenerator < DevSystem::ControllerGenerator

  # liza g axo name place=app

  def call_default
    set_default_super ""
    set_default_require ""

    @description = TtyInputCommand.prompt.ask("Do you want to add a description?", default: "No description")

    create_controller do |unit, test|
      unit.section name: :controller
      test.section name: :subject
    end
  end
  
end
