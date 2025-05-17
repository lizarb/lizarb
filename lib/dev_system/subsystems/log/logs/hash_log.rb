class DevSystem::HashLog < DevSystem::Log
  
  def self.call(menv)
    super
    hash = menv[:object]
    prefix = menv[:prefix]
    size = hash.keys.map(&:to_s).map(&:size).max

    ret = ["Hash of size #{hash.size}"]
    ret += hash.map do |k,v|
      "#{prefix}#{k.to_s.ljust size} = #{v.inspect}"
    end
    menv[:object_parsed] = ret
    true
  end

end
