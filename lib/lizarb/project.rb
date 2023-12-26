# frozen_string_literal: true

module Lizarb
  def self.project executable
    pwd = Dir.pwd
    $LOAD_PATH.unshift "#{pwd}/lib" if File.directory? "#{pwd}/lib"
    require_relative "../lizarb"

    Lizarb.setup_project pwd, project: executable

    App.systems.clear if ENV["SYSTEMS"]

    Lizarb.call
  end
end
