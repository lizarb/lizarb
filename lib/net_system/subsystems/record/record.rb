class NetSystem::Record < Liza::Controller

  def self.inherited sub
    super

    return if sub.name.nil?
    return if sub.name.end_with? "Record"
    raise "please rename #{sub.name} to #{sub.name}Record"
  end

  def self.db db = nil
    if db
      set :db, Liza.const("#{db}_db")
    else
      (get :db) || raise("please set a db to record #{self}")
    end
  end

end
