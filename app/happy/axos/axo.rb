class Axo < Liza::Axo

  # Set up your request controllers per the DSL in http://guides.lizarb.org/controllers/axo.html

  def self.call args
    cycles = args[0] || "3"
    sleep_time = args[1] || "3"

    cycles = cycles.to_i
    sleep_time = sleep_time.to_f / 10

    array = <<-HEREDOC.split("\n")
                >(.___.)<
                 >(.__.)<
                 >(.___.)<    code
                  >(.__.)<    code to
                  >(.___.)<   code to the
                   >(.__.)<   code to the right
                   >(.___.)<  code to the right
                   >(.__.)<
code                >(.___.)<
code to             >(.__.)<
code to the        >(.___.)<
code to the left   >(.__.)<
code to the left  >(.___.)<
                >(.__.)<
    HEREDOC

    cycles.times do |i|
      array.each_with_index do |s, j|
        system "clear"

        puts "Axo v0"
        puts "frame: #{j}/#{array.size}"
        puts "cycle: #{i}/#{cycles} (#{sleep_time}spf)"
        puts
        puts
        puts " " * 3 + s.bold.light_white
        puts

        sleep sleep_time
      end
    end

    puts "That was actually quite a nice workout session!".black.on_white
    puts "        We should do this again some time.     ".black.on_white

  end

end
