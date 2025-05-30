class DevSystem::LineShell < DevSystem::Shell

  section :wall_of

  def self.extract_wall_of(lines, string)
    ret = []

    state = nil
    lines.each do |line|
      if state == :entered_region
        if line.start_with? string
          ret << line
        else
          break
        end
      else
        if line.start_with? string
          state = :entered_region
          ret << line
        end
      end
    end

    ret
  end

  #

  def self.replace_wall_of(lines, string, with)
    ret = []
    
    state = nil
    lines.each do |line|

      if state == :entered_region
        if line.start_with? string
          #
        else
          ret << line
          state = nil
        end
      else
        if line.start_with? string
          ret += with
          state = :entered_region
        else
          ret << line
        end
      end

    end

    ret
  end

  section :between

  def self.extract_between(lines, range)
    ret = []

    state = nil
    lines.each do |line|
      if state == :entered_region
        if line.start_with? range.max
          break
        else
          ret << line
        end
      else
        if line.start_with? range.min
          state = :entered_region
        end
      end
    end

    ret
  end

  def self.replace_between(lines, range, with, stop_at="__END__")
    ret = []

    state = nil
    ignoring = false
    lines.each do |line|
      if state == :entered_region
        if line.start_with? range.max
          ret += with
          state = nil
        end
      else
        if line.start_with? range.min
          state = :entered_region
          ret << line
        end
      end unless ignoring

      ret << line unless state == :entered_region
      ignoring = true if line.start_with? stop_at
    end

    ret
  end
  
end
