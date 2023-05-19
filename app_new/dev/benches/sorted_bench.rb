class SortedBench < Liza::Bench

  def self.call args
    log "args = #{args.inspect}"

    # https://rubyapi.org/3.1/o/benchmark
    require "benchmark"

    if @setup_bl
      log "Setting up..."
      instance_exec &@setup_bl
      log "Set up"
    end

    log "Benchmarking #{marks.count} Ruby Blocks"
    puts

    length = marks.keys.map(&:length).max

    marks.each do |label, bl|
      log "Benchmarking #{label}"
      marks[label] = Benchmark.measure label, &bl
    end

    puts

    log "#{"Reporting".ljust_blanks(length + 17)} App CPU Time   Kernel CPU Time    Total CPU Time"
    puts

    sorted = marks.sort_by { |_k, tms| tms.total }.to_h

    sorted.each.with_index do |(label, tms), i|
      tms = tms.format "%10.6u     %10.6y         %10.6t"
      s = "[#{i.next.to_s.rjust_zeroes 2}/#{marks.count.to_s.rjust_zeroes 2}]      #{label.rjust_blanks length}   #{tms}"

      s = s.green if i == 0
      s = s.red if i == marks.count-1
      log s
    end
    puts
    log "Done"
  end

  #

  def self.marks()= @marks ||= {}

  def self.mark(label, &block)= marks[label] = block

  def self.setup &block
    @setup_bl = block if block_given?
  end

end
