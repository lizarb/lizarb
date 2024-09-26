class DevSystem::ArrayLog < DevSystem::Log
  
  def self.call(env)
    super
    array = env[:object]
    env[:object_parsed] = 
      if array.any? { _1.is_a? StickLog }
        array.join ""
      else
        prefix = env[:prefix]
        ret = ["Array of size #{array.size}"]
        ret += array.map(&:inspect).map.with_index do |v,i|
          "#{prefix}#{i.to_s.rjust_zeroes 3} = #{v}"
        end
        ret
      end
    true
  end
  
end
