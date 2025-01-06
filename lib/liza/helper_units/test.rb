class Liza::Test < Liza::Unit

  part :test_assertions
  part :test_assertions_advanced
  part :test_assertions_arythmetic
  part :test_dsl
  part :test_log
  part :test_subject
  part :test_tree

  def self.subsystem
    subject_class.subsystem
  end

  # color

  def self.color
    subject_class.color
  rescue
    # a workaround for when subject_class is not a Unit
    :white
  end
end
