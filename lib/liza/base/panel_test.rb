class Liza::PanelTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::Panel
  end

  def subject
    @subject ||= subject_class.new "name"
  end

  test_methods_defined do
    on_self :box,
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
    rescue e_class => e
      assert true, kaller: kaller
    rescue Exception => e
      assert false, kaller: kaller
    end
  end

  def refute_raises_2 e_class, &block
    kaller = caller
    begin
      block.call
      assert true, kaller: kaller
    rescue e_class => e
      assert false, kaller: kaller
    rescue Exception => e
      assert false, kaller: kaller
    end
  end

  #

  test :rescue_from, :validations do
    assert_raises_2 ArgumentError do
      subject.rescue_from(Liza)
    end
    
    assert_raises_2 ArgumentError do
      subject.rescue_from(Liza::Error)
    end
    
    refute_raises_2 ArgumentError do
      subject.rescue_from(Liza::Error) {  }
    end
    
    refute_raises_2 ArgumentError do
      subject.rescue_from(Liza::Error, with: Controller)
    end

    assert_raises_2 ArgumentError do
      subject.rescue_from(Liza::Error, with: Controller) {  }
    end
  end

  test :rescue_from, :rescuers, :rescue_from_panel do
    assert_equality subject.rescuers, []
    
    #

    subject.rescue_from(:command_panel, :parse) {  }
    actual = subject.rescuers.last
    
    #

    assert_equality actual.class, Liza::PanelRescuerPart::Rescuer
    assert_equality actual[:exception_class], CommandPanel::ParseError
    assert_equality actual[:with], nil
    assert_equality actual[:block].class, Proc

    #

    subject.rescue_from(:command_panel, :parse, with: NotFoundCommand)
    actual = subject.rescuers.last
    
    #

    assert_equality actual.class, Liza::PanelRescuerPart::Rescuer
    assert_equality actual[:exception_class], CommandPanel::ParseError
    assert_equality actual[:with], DevSystem::NotFoundCommand
    assert_equality actual[:block], nil
  end

  test :rescue_from, :rescuers, :_rescue_from_panel_find do
    assert_equality subject.rescuers, []

    subject.rescue_from(CommandPanel::ParseError, with: NotFoundCommand)
    original_rescuer = subject.rescuers.last

    assert_equality original_rescuer[:exception_class], CommandPanel::ParseError

    actual = subject._rescue_from_panel_find CommandPanel::ParseError.new

    assert_equality actual.class, Liza::PanelRescuerPart::Rescuer
    refute_equality actual, original_rescuer

    assert_equality original_rescuer[:exception], nil
    assert_equality actual[:exception].class, CommandPanel::ParseError
  end

  test :rescue_from_panel do
    todo "test this"
  end

  test :_rescue_from_parse_symbol do
    actual = subject._rescue_from_parse_symbol(:error)
    assert_equality Liza::Error, actual

    assert_raises_2 NameError do
      subject._rescue_from_parse_symbol(:errorx)
    end
  end

  test :_rescue_from_parse_symbols do
    actual = subject._rescue_from_parse_symbols([:command_panel, :parse])
    assert_equality CommandPanel::ParseError, actual

    actual = subject._rescue_from_parse_symbols([:command_panel, :not_found])
    assert_equality CommandPanel::NotFoundError, actual

    assert_raises_2 NameError do
      subject._rescue_from_parse_symbols([:command_panel, :not_foxund])
    end
  end

  #

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  #

  test :short do
    assert_equality subject.short("m"), "m"
    assert_equality subject.short("i"), "i"
    assert_equality subject.short("n"), "n"
    assert_equality subject.short("s"), "s"
    assert_equality subject.short("w"), "w"
    assert_equality subject.short("a"), "a"
    assert_equality subject.short("n"), "n"

    subject.short :m, :matz
    subject.short :i, :is
    subject.short :n, :nice
    subject.short :s, :so
    subject.short :w, :we
    subject.short :a, :are

    assert_equality subject.short("m"), "matz"
    assert_equality subject.short("i"), "is"
    assert_equality subject.short("n"), "nice"
    assert_equality subject.short("s"), "so"
    assert_equality subject.short("w"), "we"
    assert_equality subject.short("a"), "are"
    assert_equality subject.short("n"), "nice"
  end

end
