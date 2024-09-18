class LabSystem::DockerShell < DevSystem::Shell

  #

  def self.hello_world
    KernelShell.call_system "sudo docker run hello-world"

    true
  end

  # 

  def self.hello_alpine
    KernelShell.call_system "sudo docker run alpine echo 'hello world'"

    true
  end

  # 

  def self.version
    output = KernelShell.call_backticks "sudo docker version"
    parse_version output
  end

  def self.parse_version output
    h = {}
    current_section = current_sub = nil
    
    output.each_line do |line|
      line = line.strip
      next if line.empty?

      if line.start_with?("Client:")

        name = line.split(":", 2).last.strip
        current_section = h["Client"] = {"Name" => name}
        current_sub = current_section

      elsif line.start_with?("Server:")
        name = line.split(":", 2).last.strip
        current_section = h["Server"] = {"Name" => name}

      elsif current_section

        if line.end_with?(":")
          key = line.chomp(":")
          current_sub = current_section[key] = {}
        elsif line.include?(":")
          key, value = line.split(":", 2).map(&:strip)
          current_sub[key] = value
        end

      end
    end

    h
  end

end
