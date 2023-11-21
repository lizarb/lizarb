class DevSystem::Command < Liza::Controller

  def self.call args
    log "args = #{args}"
    new.call args
  end

  def call args
    log "args = #{args}"
    raise NotImplementedError
  end

  def self.get_command_signatures
    signatures = []
    ancestors_until(Command).each do |c|
      signatures +=
        c.methods_defined.select do |name|
          c.method(name).parameters == [[:req, :args]]
        end.map do |name|
          OpenStruct.new({
            name: ( name == :call ? "" : name.to_s ),
            description: "# no description",
          })
        end
    end
    signatures
  end
end
