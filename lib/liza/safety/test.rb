class Liza::Test < Liza::Unit

  part :test_assertions
  part :test_assertions_advanced
  part :test_dsl
  part :test_log
  part :test_subject
  part :test_tree

  def self.subsystem
    subject_class.subsystem
  end

end
