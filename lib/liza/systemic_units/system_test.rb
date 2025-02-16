class Liza::SystemTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::System
  end

  test_sections(
    :default=>{
      :constants=>[],
      :class_methods=>[:const, :subs, :subsystems, :panel, :token, :box, :system, :color, :log, :puts],
      :instance_methods=>[:log, :puts]
    }
  )

end
