class DevSystem::LineShell < DevSystem::Shell

  #

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
  
end
