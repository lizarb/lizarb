class DevSystem::Generator < Liza::Controller

  def self.get_generator_signatures
    signatures = []
    ancestors_until(Generator).each do |c|
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
