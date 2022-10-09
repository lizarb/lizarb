class SqliteDb < Liza::SqliteDb

  # Set up your database controllers per the DSL in http://guides.lizarb.org/controllers/database.html

  def table_names
    result = call "SELECT name FROM sqlite_schema;"
    result.delete_at 0
    result.flatten
  end

end
