class DevSystem::BenchGenerator < DevSystem::ControllerGenerator
  
  section :actions
  
  # liza g bench name place=app +sorted
  
  def call_default
    if FileShell.exist? "#{App.directory}/dev/benches/sorted_bench.rb"
      log "sorted_bench.rb detected!"

      set_default_boolean :sorted, true
      set_input_boolean :sorted do |default|
        TtyInputCommand.prompt.yes? "Use SortedBench?", default: !!default
      end
      
      sorted = command.simple_boolean :sorted
      set_default_super "sorted" if sorted
    end

    create_controller do |unit, test|
      unit.section name: :setup
      unit.section name: :marks
      test.section name: :subject
    end
  end

  # liza g bench:examples

  def call_examples
    copy_examples Bench
  end

end

