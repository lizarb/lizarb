class Liza::PanelTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::Panel
  end

  def subject
    @subject ||= subject_class.new "name"
  end

  test_methods_defined do
    on_self \
      :box,
      :color,
      :controller,
      :puts,
      :subsystem,
      :token
    on_instance \
      :box,
      :controller, :division,
      :key, :push,
      :rescue_from, :rescue_from_panel, :rescuers,
      :short, :started,
      :subsystem
  end

  #

  def assert_raises_2 e_class, &block
    kaller = caller
    begin
      block.call
      assert false, kaller: kaller
    rescue e_class
      assert true, kaller: kaller
    rescue Exception
      assert false, kaller: kaller
    end
  end

  def refute_raises_2 e_class, &block
    kaller = caller
    begin
      block.call
      assert true, kaller: kaller
    rescue e_class
      assert false, kaller: kaller
    rescue Exception
      assert false, kaller: kaller
    end
  end

  #

  test :define_error do
    todo "test this"
  end

  test :raise_error do
    todo "test this"
  end

  #
  
  test :instance do
    assert_equality BenchPanel.instance, DevBox.panels[:bench]
  end

end
