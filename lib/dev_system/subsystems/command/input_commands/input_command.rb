class DevSystem::InputCommand < DevSystem::Command

  #

  division!

  #

  def self.call env
    super
    args = env[:args]
    log "args = #{args.inspect}"
  end

  def self.pick_one title, options = ["Yes", "No"]
    log "#{title} #{options.inspect}"

    s = Kernel.gets.chomp.downcase
    options.find { _1.downcase.start_with? s } || options.first
  end

end
