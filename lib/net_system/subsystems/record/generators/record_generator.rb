class NetSystem::RecordGenerator < DevSystem::ControllerGenerator

  section :actions
  
  # liza g record name place=app

  def call_default
    set_default_super ""
    set_default_require ""

    @database = command.simple_string :database

    create_controller do |unit, test|
      unit.section name: :controller
      test.section name: :test
    end
  end

  section :helpers

  # set_default_string :database, "sqlite"

  set_input_string :database do |default|
    options = Database.subunits.map do |database|
      s = database.last_namespace.snakecase.sub("_db", "")
      [
        s,
        s
      ]
    end.to_h

    TtyInputCommand.pick_one "Which database?", options
  end
  
end
