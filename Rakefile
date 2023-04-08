# frozen_string_literal: true

require "bundler/gem_tasks"

# Replaced tasks

task default: %i[] do
  system "lizarb test"
end

# Custom tasks



# Custom prerequisite tasks

task :custom_gemfiles do
  puts "... Bundling app_global.gemfile.rb"
  system "VERBOSE=1 BUNDLE_GEMFILE=app_global.gemfile.rb bundle update"

  puts "... Bundling Gemfile"
  system "VERBOSE=1 BUNDLE_GEMFILE=Gemfile bundle"

  puts "... Installing lizarb"
end

# Custom post-requisite tasks

task :custom_post_task do
  puts "! Done"
  # Add your custom behavior here
end

# Enhance

# Enhance the existing `build` task with the prerequisite

Rake::Task["build"].enhance [:custom_gemfiles]

# Enhance the existing `install` task with the post-requisite

Rake::Task["install"].enhance do
  Rake.application.invoke_task :custom_post_task
end
