class WorkSystem::EventPanelTest < Liza::PanelTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, WorkSystem::EventPanel
    assert_equality subject.class, WorkSystem::EventPanel
  end

  test_sections(
    :subsystem=>{
      :constants=>[:NotFoundError],
      :class_methods=>[],
      :instance_methods=>[:call]
    }
  )

  test :settings do
    assert_equality subject.log_level, 4
  end

end
