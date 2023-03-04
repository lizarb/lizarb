class NetSystem::NetBoxTest < Liza::BoxTest

  test :subject_class do
    assert subject_class == NetSystem::NetBox
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :red
  end

  test :panels do
    assert subject_class[:client].is_a? NetSystem::ClientPanel
    assert subject_class[:database].is_a? NetSystem::DatabasePanel
  end

end
