class ObjectsBench < SortedBench

  setup do
    N = 1_000_000
    # N = 10_000_000
    # N = 100_000_000

    log "setup N = #{N}"
  end

  mark "BasicObject.new" do
    i = 0

    while (i += 1) <= N
      BasicObject.new
    end
  end

  mark "Object.new" do
    i = 0

    while (i += 1) <= N
      Object.new
    end
  end

  mark "String.new" do
    i = 0

    while (i += 1) <= N
      String.new
    end
  end

  mark "Numeric.new" do
    i = 0

    while (i += 1) <= N
      Numeric.new
    end
  end

  mark "Time.new" do
    i = 0

    while (i += 1) <= N
      Time.new
    end
  end

  mark "Proc.new {}" do
    i = 0

    while (i += 1) <= N
      Proc.new {}
    end
  end

  mark "Set.new" do
    i = 0

    while (i += 1) <= N
      Set.new
    end
  end

  mark "Array.new" do
    i = 0

    while (i += 1) <= N
      Array.new
    end
  end

  mark "Hash.new" do
    i = 0

    while (i += 1) <= N
      Hash.new
    end
  end

end
