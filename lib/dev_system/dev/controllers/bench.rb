class DevSystem::Bench < Liza::Controller

  # DSLS

  def self.main_dsl
    part :"bench_dsl_main", system: :dev
  end

end
