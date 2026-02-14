class DevSystem::BoxesGenerator < DevSystem::SimpleGenerator
  
  # liza g boxes

  def call_default
    list = Dir["#{ App.directory_name }/*"].to_set

    App.systems.each do |k, klass|
      next if klass.subs.empty?

      box_file = "#{ App.directory_name }/#{ k }_box.rb"
      next if list.include? box_file

      name = "#{ App.directory_name }/#{k}_box.rb"
      contents = klass.box.new.render! :default, format: :rb
      contents = FileShell.read_text Lizarb.gem_dir / "examples/new/app/dev_box.rb" if k == :dev

      create_file_contents name, contents
    end
  end
  
end
