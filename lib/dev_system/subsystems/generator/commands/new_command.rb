class DevSystem::NewCommand < DevSystem::SimpleCommand

  # liza new [name]

  def call_default
    call_project
  end

  # liza new:project [name]

  def call_project
    DevBox.command ["generate", "new:project", *args]
  end

  # liza new:script [name]

  def call_script
    DevBox.command ["generate", "new:script", *args]
  end

  # liza new:script_dependent [name]
  
  def call_script_dependent
    DevBox.command ["generate", "new:script_dependent", *args]
  end

  # liza new:script_independent [name]
  
  def call_script_independent
    DevBox.command ["generate", "new:script_independent", *args]
  end

end
