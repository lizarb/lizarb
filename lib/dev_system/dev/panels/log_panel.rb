class DevSystem
  class LogPanel < Liza::Panel

    # https://rubyapi.org/3.1/o/logger
    def call string
      puts "lizarb #{Lizarb.thread_id.to_s.rjust_zeroes 3} #{string}"
    end

  end
end
