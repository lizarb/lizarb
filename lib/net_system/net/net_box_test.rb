class NetSystem
  class NetBoxTest < Liza::BoxTest

    test :subject_class do
      assert subject_class == NetSystem::NetBox
    end

    test :settings do
      assert subject_class.log_level == :normal
      assert subject_class.log_color == :red
    end

    test :panels do
      assert subject_class.adapters.is_a? AdapterPanel
      assert subject_class.databases.is_a? DatabasePanel
    end

  end
end
