# frozen_string_literal: true

class Class
  public :eval

  def descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  def first_namespace
    name.rpartition('::')[0]
  end

  def last_namespace
    name.rpartition('::')[-1]
  end
end
