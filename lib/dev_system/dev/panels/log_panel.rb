class DevSystem
  class LogPanel < Liza::Panel

    # https://rubyapi.org/3.1/o/logger
    def call string
      puts string
    end

  end
end
