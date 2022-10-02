# frozen_string_literal: true

require_relative "lib/lizarb/version"

Gem::Specification.new do |spec|
  spec.name = "lizarb"
  spec.version = Lizarb::VERSION
  spec.authors = "Thiago Pinto"
  spec.email = "thiagopintodev@gmail.com"

  spec.summary = "Application Framework"
  spec.description = "Liza is a light, experimental framework primarily developed to help study the Ruby language and the Ruby ecosystem."
  spec.homepage = "http://lizarb.org"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata = {
    "homepage_uri"    => "https://github.com/rubyonrails-brasil/lizarb",
    "changelog_uri"   => "https://github.com/rubyonrails-brasil/lizarb/blob/main/CHANGELOG.md",
    "source_code_uri" => "https://github.com/rubyonrails-brasil/lizarb",
    "bug_tracker_uri" => "https://github.com/rubyonrails-brasil/lizarb/issues"
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = ["liza", "lizarb"]
  spec.require_paths = ["lib"]

  # dependencies

  spec.add_dependency "colorize", "~> 0.8"
  spec.add_dependency "dotenv", "~> 2.8"
  spec.add_dependency "zeitwerk", "~> 2.6"

  # development dependencies

  spec.add_development_dependency "rake", "~> 13.0"
end
