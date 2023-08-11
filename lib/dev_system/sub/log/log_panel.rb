class DevSystem::LogPanel < Liza::Panel

  # https://rubyapi.org/3.1/o/logger
  def call string
    unless $coding
      pid = Process.pid
      tid = Lizarb.thread_id.to_s.rjust_zeroes 3
      string = "#{pid} #{tid} #{string}"
    end
    puts string
  end

end
