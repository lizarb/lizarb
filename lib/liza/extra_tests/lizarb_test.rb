class Liza::LizarbTest < Liza::ObjectTest
  
  test :subject_class do
    assert_equality subject_class, Lizarb
  end

  # NOTE: this test can only be run in complete isolation from other tests
  # test :reload do
  #   array = []
  #   3.times do
  #     Lizarb.reload do
  #       # AppShell.consts
  #       app_shell = AppShell.new
  #       app_shell.filter_by_unit Request
  #       app_shell.get_domains
  #       array << SimpleCommand.object_id
  #     end
  #   end
  #   assert_equality array.uniq.size, 3
  # end

end
