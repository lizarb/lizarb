class DevSystem
  class CommandPanel < Liza::Panel

    def call args
      command_klass = Liza.const "#{args[0]}_command"
      command_klass.call args[1..-1]
    end

  end
end
