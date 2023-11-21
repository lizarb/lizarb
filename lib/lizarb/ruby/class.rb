# frozen_string_literal: true

class Class

  def descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  def and_descendants
    ObjectSpace.each_object(Class).select { |klass| klass <= self }
  end
  
  def ancestors_until klass
    ancestors.take_while { _1 <= klass }
  end

  def first_namespace
    name.rpartition('::')[0]
  end

  def last_namespace
    name.rpartition('::')[-1]
  end

end
