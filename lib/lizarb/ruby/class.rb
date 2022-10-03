# frozen_string_literal: true

class Class
  def first_namespace
    name.rpartition('::')[0]
  end
end
