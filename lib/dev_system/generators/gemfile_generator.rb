class DevSystem::GemfileGenerator < DevSystem::SimpleGenerator

  # liza g gemfile

  def call_default
    @gemspec_name = get_gemspec_name

    fname = command.given_args[1] || "Gemfile"

    create_file fname, :gemfile, :rb
  end

  def get_gemspec_name
    # ls = Dir["*.gemspec"]
    # ls.first.split(".").first if ls.any?
    false
  end

end
