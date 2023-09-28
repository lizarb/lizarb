class DevSystem::LineDiffShell < DevSystem::Shell

  # 

  def self.log_diff(a, b)
    require "diff/lcs"

    # Compute the diff
    diffs = Diff::LCS.diff(a, b)
    puts
    # Output the diff in a format similar to git diff
    diffs.each do |diff|
      diff.each do |change|
        # If it's a deletion (present in old but not in new)
        if change.action == "-"
          puts "- #{change.element.chomp.red}"
        # If it's an addition (present in new but not in old)
        elsif change.action == "+"
          puts "+ #{change.element.chomp.green}"
        end
      end
    end
    puts
  end
  
end
