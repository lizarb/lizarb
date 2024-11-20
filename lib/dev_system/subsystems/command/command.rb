class DevSystem::Command < Liza::Controller

  def self.get_command_signatures()= []

  section :shortcuts

  def self.shortcuts () = @shortcuts ||= {}
  
  def self.shortcut(a, b = nil)
    if b
      shortcuts[a.to_s] = b.to_s
    else
      shortcuts[a.to_s] || a.to_s
    end
  end
  
end
