class ObjectsBench < SortedBench

  repetitions 1_000_000
  # repetitions 10_000_000
  # repetitions 100_000_000

  setup do
    log "repetitions: #{repetitions}"
  end
  #

  mark "BasicObject.new" do
    BasicObject.new
  end

  mark "Object.new" do
    Object.new
  end

  mark "String.new" do
    String.new
  end

  mark "Numeric.new" do
    Numeric.new
  end

  mark "Time.new" do
    Time.new
  end

  mark "Proc.new {}" do
    Proc.new {}
  end

  mark "Set.new" do
    Set.new
  end

  mark "Array.new" do
    Array.new
  end

  mark "Hash.new" do
    Hash.new
  end

end
