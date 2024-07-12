# frozen_string_literal: true

module Lizarb
  def self.script(
    *systems,
    app:
  )
    pwd = Dir.pwd
    $LOAD_PATH.unshift "#{pwd}/lib" if File.directory? "#{pwd}/lib"
    require_relative "../lizarb"
    cl = caller_locations(1, 1)[0]
    
    raise Lizarb::Error, "Lizarb.script does not support app_global, use Lizarb.sfa" if app == "app_global"
    raise Lizarb::Error, "#{app.inspect} does not start with 'app_'" unless app == "app" or app.to_s.start_with? "app_"

    segments = cl.absolute_path.split("/")
    root, script = segments[0..-3].join("/"), segments[-2..-1].join("/")

    Lizarb.setup_script root, script: script, script_app: app

    App.class_exec do
      self.systems.clear if systems.any?
      systems.each do |key|
        system key
      end
    end
    Lizarb.load
  end
end
