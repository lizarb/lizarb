# frozen_string_literal: true

class Class
  def descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  def first_namespace
    name.rpartition('::')[0]
  end
end
