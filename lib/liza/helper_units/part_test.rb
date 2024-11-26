class Liza::PartTest < Liza::UnitTest

  section :unit

  def self.color() = system.color
  
  section :default

  test :subject_class do
    assert subject_class == Liza::Part
  end

  test_methods_defined do
    on_self :insertion
    on_instance
  end

end
