class MicroSystem::ShipGenerator < DevSystem::ControllerGenerator


  section :actions

  # set_default_views "none"
  # set_default_views "eof"
  # set_default_views "adjacent"
  # set_default_views "nested"

  def arg_action_names
    ret = super
    ret = ["hello_world"] if ret.empty?
    ret
  end

  # liza g ship name action_1 action_2 action_3
  def call_default
    call_docker
  end

  def call_docker
    set_default_super "docker"

    create_controller do |unit, test|
      unit.section name: :services, render_key: :section_docker

      test.section name: :subject
      test.section name: :services, render_key: :section_docker_test
    end
  end

end
