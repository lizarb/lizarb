class VariablesBench < SortedBench

  setup do
    LETTERS = (Array("a".."z")+Array("A".."Z"))
    N = 1_000
    # N = 10_000
    # N = 100_000
    
    log "setup N = #{N}"
  end

  mark "local variable" do
    i = 0
    a = nil

    while (i += 1) <= N
      eval "v_#{random_name} = sample"
    end
  end

  mark "instance variable" do
    i = 0

    while (i += 1) <= N
      eval "@v_#{random_name} = sample"
    end
  end

  mark "class variable" do
    i = 0

    while (i += 1) <= N
      eval "@@v_#{random_name} = sample"
    end
  end

  mark "global variable" do
    i = 0

    while (i += 1) <= N
      eval "$v_#{random_name} = sample"
    end
  end

  # helper methods

  def self.random_name
    LETTERS.shuffle.join("")
  end

  def self.sample
    LETTERS.sample
  end

end
