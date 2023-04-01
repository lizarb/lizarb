class NewCommandTest < Liza::CommandTest

  test :subject_class do
    assert subject_class == NewCommand
  end

end
