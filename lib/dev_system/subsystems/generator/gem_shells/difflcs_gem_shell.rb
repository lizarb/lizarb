class DevSystem::DifflcsGemShell < DevSystem::GemShell
  require "diff/lcs"
  # gem "diff-lcs"

  def self.get_diffs(a, b)
    call({})
    Diff::LCS.diff(a, b)
  end

  def self.log_diff(a, b)
    diffs = get_diffs(a, b)
    puts
    # Output the diff in a format similar to git diff
    diffs.each do |diff|
      diff.each do |change|
        # If it's a deletion (present in old but not in new)
        if change.action == "-"
          puts "- #{stick change.element.chomp, :light_red}"
        # If it's an addition (present in new but not in old)
        elsif change.action == "+"
          puts "+ #{stick change.element.chomp, :light_green}"
        end
      end
    end
    puts
  end

end
