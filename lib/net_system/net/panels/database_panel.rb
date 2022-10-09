class NetSystem
  class DatabasePanel < Liza::Panel

    def define key, instance
      set key, instance
      define_singleton_method key do
        get key
      end
    end

  end
end
