class NetSystem
  class Model < Liza::Controller

    def self.inherited sub
      super

      return if sub.name.nil?
      return if sub.name.end_with? "Model"
      raise "please rename #{sub.name} to #{sub.name}Model"
    end

    def self.db database_id = nil
      if database_id.nil?
        db = get :db
        if db
          NetBox.databases.get db
        else
          raise "please set a db to model #{self}"
        end
      else
        valid = NetBox.databases.settings.keys
        if valid.include? database_id
          set :db, database_id
        else
          raise "invalid db, valid options are #{valid}"
        end
      end
    end

  end
end
