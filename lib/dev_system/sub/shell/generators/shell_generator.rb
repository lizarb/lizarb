class DevSystem::ShellGenerator < DevSystem::SimpleGenerator
  
  # liza g shell:examples

  def call_examples
    copy_examples Shell
  end

end
