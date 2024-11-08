class DevSystem::BoxesGenerator < DevSystem::SimpleGenerator
  
  # liza g boxes

  def call_default
    app_dir = App.path
    
    list = Dir["#{ app_dir }/*"].to_set

    App.systems.each do |k, klass|
      next if klass.subs.empty?

      box_file = "#{ app_dir }/#{ k }_box.rb"
      next if list.include? box_file

      name = "#{ App.folder }/#{k}_box.rb"
      b = klass.box.new
      contents = b.render! :default, format: :rb

      create_file_contents name, contents
    end
  end
  
end
