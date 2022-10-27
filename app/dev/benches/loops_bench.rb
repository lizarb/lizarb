class LoopsBench < AppBench

  main_dsl

  N = 10_000_000
  RANGE = 1..N

  mark "for i in RANGE" do
    for i in RANGE
      a = "1"
    end
  end

  mark "N.times do" do
    N.times do
      a = "1"
    end
  end

  mark "N.times do |i|" do
    N.times do |i|
      a = "1"
    end
  end

  mark "RANGE.each do" do
    RANGE.each do
      a = "1"
    end
  end

  mark "RANGE.each do |i|" do
    RANGE.each do |i|
      a = "1"
    end
  end

  mark "1.upto N do" do
    1.upto N do
      a = "1"
    end
  end

  mark "1.upto N do |i|" do
    1.upto N do |i|
      a = "1"
    end
  end

end
