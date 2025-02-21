class Liza::LizarbTest < Liza::ObjectTest
  
  test :subject_class do
    assert_equality subject_class, Lizarb
  end

  test :reload do
    array = []
    3.times do
      Lizarb.reload do
        array << SimpleCommand.object_id
      end
    end
    assert_equality array.uniq.size, 3
  end
    
end
