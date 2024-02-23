class NetSystem::DatabasePanelTest < Liza::PanelTest

  test :subject_class do
    assert_equality subject_class, NetSystem::DatabasePanel
    refute_equality subject, NetBox[:database]
  end

  # test :call do
  #   todo "write this"
  # end

end
