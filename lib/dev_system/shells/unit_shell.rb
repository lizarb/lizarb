class DevSystem::UnitShell < DevSystem::Shell

  # Returns a flattened array of all subunits for a given unit.
  # 
  # @param unit [Object] The unit to retrieve subunits for.
  # @return [Array] A flattened array of subunits.
  def self.subunits_flat(unit)
    ret = []
    
    rec = get_subunits_recursive(unit)
    while rec.is_a? Hash
      rec.each do |subunit, next_subs|
        ret << subunit
        rec = next_subs
      end
    end
    ret += rec

    ret
  end

  # Recursively retrieves subunits for a given unit and caches the result.
  # 
  # @param unit [Object] The unit to retrieve subunits for.
  # @return [Array, Hash] An array or hash of subunits.
  def self.get_subunits_recursive(unit)
    subs = unit.subunits
    return [] if subs.empty?
    h = subs.map do |subunit|
      next_subs = get_subunits_recursive(subunit)
      [subunit, next_subs]
    end.to_h
    if h.values.all?(&:empty?)
      h.keys
    else
      h
    end
  end

end
