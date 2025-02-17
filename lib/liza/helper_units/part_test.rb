class Liza::PartTest < Liza::UnitTest

  section :unit

  def self.color() = system.color
  
  section :default

  test :subject_class do
    assert subject_class == Liza::Part
  end

  test_sections(
    :unit=>{
      :constants=>[],
      :class_methods=>[:color],
      :instance_methods=>[]
    },
    :default=>{
      :constants=>[],
      :class_methods=>[:insertions, :insertion, :log, :puts],
      :instance_methods=>[:log, :puts]
    }
  )

end
