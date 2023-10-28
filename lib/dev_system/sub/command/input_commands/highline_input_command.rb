class DevSystem::HighlineInputCommand < DevSystem::InputCommand

  def self.highline
    require "highline"
    @highline ||= HighLine.new
  end

  def self.pick_one title, options = ["Yes", "No"]
    highline.choose do |menu|
      menu.prompt = title
      options.each do |option|
        menu.choice option
      end
    end
  end

end
