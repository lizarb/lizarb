class DevSystem
  class Generator < Liza::Controller

    # DSLS

    def self.main_dsl
      part :"generator_dsl_main", system: :dev
    end

  end
end
