class AppModel < Liza::Model
  db :sqlite

  def self.create_tables!
    db.call <<-SQLITE
CREATE TABLE #{get :table} (
  id integer,
  name text,
  text text
);
SQLITE
  end

  def self.drop_tables!
    db.call <<-SQLITE
DROP TABLE #{get :table};
SQLITE
  end

end
