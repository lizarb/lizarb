class DevSystem::HashLog < DevSystem::Log
  
  def self.call(env)
    super
    hash = env[:object]
    prefix = env[:prefix]
    size = hash.keys.map(&:to_s).map(&:size).max

    ret = ["Hash of size #{hash.size}"]
    ret += hash.map do |k,v|
      "#{prefix}#{k.to_s.ljust size} = #{v.inspect}"
    end
    env[:object_parsed] = ret
    true
  end

end
