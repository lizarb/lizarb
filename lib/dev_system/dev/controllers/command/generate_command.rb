class DevSystem::GenerateCommand < DevSystem::Command

  def self.call args
    # 1. LOG

    log :higher, "args: #{args}"
    puts

    # 2. FIND generator

    return call_not_found args if args.none?

    generator = args[0]

    log({generator:})

    #

    begin
      generator_class = Liza.const "#{generator}_generator"
    rescue Liza::ConstNotFound
      generator_class = NotFoundGenerator
    end

    # 3. CALL

    generator_class.call args[1..-1]
  end

  def self.call_not_found args
    Liza::NotFoundGenerator.call args
  end
end
