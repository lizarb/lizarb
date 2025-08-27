class SortedBench < DevSystem::Bench
  # https://rubyapi.org/3.1/o/benchmark
  require "benchmark"

  def self.call(menv)
    super
    t = Time.now

    log stick system.color, :b, (" MEASURE, DO NOT GUESS ".center 80, "-")
    log "repetitions #{repetitions}"

    if @setup_bl
      log "Setting up..."
      @setup_bl.call
    end

    log "Benchmarking #{marks.count} Ruby Blocks"
    puts

    length = marks.keys.map(&:length).max || 0

    marks.each do |label, bl|
      log "Benchmarking #{label}"
      marks[label] = Benchmark.measure label do
        i = 0
        bl.call while (i += 1) <= repetitions
      end
    end

    puts

    log "#{"Reporting".ljust_blanks(length + 17)} App CPU Time   Kernel CPU Time    Total CPU Time"
    puts

    sorted = marks.sort_by { |_k, tms| tms.total }.to_h

    bars_lengths = calculate_bars(sorted)
    bars   = bars_lengths.map { "■" * _1 }

    sorted.each.with_index do |(label, tms), i|
      tms = tms.format "%10.6u     %10.6y         %10.6t"
      s = "[#{i.next.to_s.rjust_zeroes 2}/#{marks.count.to_s.rjust_zeroes 2}]      #{label.rjust_blanks length}   #{tms}  #{bars[i]}"

      s = (stick s, :light_green).to_s if i == 0
      s = (stick s, :light_red  ).to_s if i == marks.count-1
      log s
    end
    puts
  ensure
    log "#{time_diff t}s | #{marks.count} marks | #{repetitions} repetitions"
  end

  #

  def self.repetitions n = nil
    if n
      @repetitions = n
    else
      @repetitions ||= 1
    end
  end

  #

  def self.setup &block
    @setup_bl = block if block_given?
  end

  #

  def self.marks()= @marks ||= {}

  def self.mark(label, &block)= marks[label] = block

  #

  def self.calculate_bars(sorted, max_bar_size = 20)
    times    = sorted.values.map(&:total)
    min_time = times.min
    max_time = times.max
    range    = max_time - min_time

    lengths = if times.size <= 3
      times.map do |time|
        proportion = time / max_time.to_f
        bar_length = (proportion * max_bar_size).round
        bar_length = 1 if bar_length.zero? && time > 0
        bar_length
      end
    else
      times.map do |time|
        proportion = range.zero? ? 1.0 : (time - min_time) / range.to_f
        bar_length = (proportion * max_bar_size).round

        bar_length
      end
    end

    lengths
  end

end
