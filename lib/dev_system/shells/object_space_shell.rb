class DevSystem::ObjectSpaceShell < DevSystem::Shell

  def self.instances_of(klass)
    ObjectSpace.each_object(klass).to_a
  end

  def self.get_class(cname)
    Object.const_get(cname)
  end

end
