class PrimeSystem::InsightPanelTest < Liza::PanelTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, PrimeSystem::InsightPanel
    assert_equality subject.class, PrimeSystem::InsightPanel
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
