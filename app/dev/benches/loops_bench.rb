class LoopsBench < AppBench
  main_dsl

  setup do
    N = 1_000_000
    RANGE = 1..N
    ARRAY = Array RANGE
    HASH_INT = RANGE.map { |i| [i, i] }.to_h
    HASH_STR = RANGE.map { |i| ["a#{i}", i] }.to_h
    HASH_SYM = RANGE.map { |i| [:"a#{i}", i] }.to_h
  end

  mark "for i in RANGE" do
    for i in RANGE
      a = "1"
    end
  end

  mark "for i in ARRAY" do
    for i in ARRAY
      a = "1"
    end
  end

  mark "for i, iv in HASH_INT" do
    for i, iv in HASH_INT
      a = "1"
    end
  end

  mark "for i, iv in HASH_STR" do
    for i, iv in HASH_STR
      a = "1"
    end
  end

  mark "for i, iv in HASH_SYM" do
    for i, iv in HASH_SYM
      a = "1"
    end
  end

  mark "RANGE.each do |i|" do
    RANGE.each do |i|
      a = "1"
    end
  end

  mark "ARRAY.each do |i|" do
    ARRAY.each do |i|
      a = "1"
    end
  end

  mark "HASH_INT.each do |i, iv|" do
    HASH_INT.each do |i, iv|
      a = "1"
    end
  end

  mark "HASH_STR.each do |i, iv|" do
    HASH_STR.each do |i, iv|
      a = "1"
    end
  end

  mark "HASH_SYM.each do |i, iv|" do
    HASH_SYM.each do |i, iv|
      a = "1"
    end
  end

  mark "RANGE.map do |i|" do
    RANGE.map do |i|
      a = "1"
    end
  end

  mark "ARRAY.map do |i|" do
    ARRAY.map do |i|
      a = "1"
    end
  end

  mark "HASH_INT.map do |i, iv|" do
    HASH_INT.map do |i, iv|
      a = "1"
    end
  end

  mark "HASH_STR.map do |i, iv|" do
    HASH_STR.map do |i, iv|
      a = "1"
    end
  end

  mark "HASH_SYM.map do |i, iv|" do
    HASH_SYM.map do |i, iv|
      a = "1"
    end
  end

  mark "N.times do |i|" do
    N.times do |i|
      a = "1"
    end
  end

  mark "1.upto N do |i|" do
    1.upto N do |i|
      a = "1"
    end
  end

  mark "loop break" do
    i = 0

    loop do
      a = "1"
      break unless (i += 1) <= N
    end
  end

  mark "while" do
    i = 0

    while (i += 1) <= N
      a = "1"
    end
  end

  mark "begin end while" do
    i = 0

    begin
      a = "1"
    end while (i += 1) <= N
  end

  mark "begin end until" do
    i = 0

    begin
      a = "1"
    end until (i += 1) == N
  end

end
