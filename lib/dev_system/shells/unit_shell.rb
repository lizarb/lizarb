class DevSystem::UnitShell < DevSystem::Shell

  # Returns a flattened array of all subunits for a given unit.
  # 
  # @param unit [Object] The unit to retrieve subunits for.
  # @return [Array] A flattened array of subunits.
  def self.subunits_flat(unit)
    subunits_recursive(unit).flatten
  end

  # Recursively retrieves all subunits for a given unit.
  # 
  # @param unit [Object] The unit to retrieve subunits for.
  # @return [Array, Hash] An array or hash of subunits.
  def self.subunits_recursive(unit)
    cached_subunits[unit] ||= get_subunits_recursive(unit)
  end

  # Returns a cached hash of subunits.
  # 
  # @return [Hash] A hash where keys are units and values are their subunits.
  def self.cached_subunits
    @cached_subunits ||= {}
  end

  # Recursively retrieves subunits for a given unit and caches the result.
  # 
  # @param unit [Object] The unit to retrieve subunits for.
  # @return [Array, Hash] An array or hash of subunits.
  def self.get_subunits_recursive(unit)
    # this eager loads all units in all systems
    AppShell.consts
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
