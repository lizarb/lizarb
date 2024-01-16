class NetSystem::NetBoxTest < Liza::BoxTest

  test :subject_class do
    assert subject_class == NetSystem::NetBox
  end

  test :panels do
    assert subject_class[:client].is_a? NetSystem::ClientPanel
    assert subject_class[:database].is_a? NetSystem::DatabasePanel
  end

end
