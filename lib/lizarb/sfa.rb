# frozen_string_literal: true

module Lizarb
  def self.sfa(
    *systems,
    mode: :code,
    folder: nil,
    gemfile: nil,
    log_handler: :output,
    log_boot: nil,
    log_level: nil,
    log: nil,
    pwd: 
  )
    require_relative "../lizarb"
    log_boot  ||= log if log
    log_level ||= log if log
    log_boot  ||= :normal
    log_level ||= :normal
    
    cl = caller_locations(1, 1)[0]
    
    sfa = cl.absolute_path

    Lizarb.setup_sfa pwd, sfa: sfa

    App.class_exec do
      self.gemfile gemfile
      self.folder folder if folder
      self.log_boot log_boot
      self.log_level log_level
      self.mode mode
      system :dev
      systems.each do |key|
        system key
      end
    end
    
    Lizarb.load

    DevSystem::DevBox.configure :log do
      handler log_handler
    end
  end
end
