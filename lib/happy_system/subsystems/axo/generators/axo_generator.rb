class HappySystem::AxoGenerator < DevSystem::SimpleGenerator

  # liza g axo name place=app

  def call_default
    @controller_class = Axo

    name!
    place!

    @description = TtyInputCommand.prompt.ask("Do you want to add a description?", default: "No description")

    @args = command.simple_args[1..-1]

    create_controller @name, @controller_class, @place, @path do |unit, test|
      unit.section :controller_section_1, caption: ""
      test.section :controller_test_section_1, caption: ""
    end
  end
  
end

__END__

# view controller_section_1.rb.erb

  set :description, <%= @description.inspect %>

  # liza axo <%= @name %> 2 2
  def call(args)
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
        KernelShell.call_system "clear"

        puts "Axo v0"
        puts "frame: #{j}/#{array.size}"
        puts "cycle: #{i}/#{cycles} (#{sleep_time}spf)"
        puts
        puts
        puts "   #{stick s, :bold, :light_white}"
        puts

        sleep sleep_time
      end
    end

    puts stick "That was actually quite a nice workout session!", :black, :white
    puts stick "        We should do this again some time.     ", :black, :white

  end
# view controller_test_section_1.rb.erb

  # test :subject_class, :subject do
  #   assert_equality <%= @class_name %>, subject_class
  #   assert_equality <%= @class_name %>, subject.class
  # end
