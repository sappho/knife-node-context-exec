require 'rake'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

task default: [:rubocop_dev]
task ci: [:rubocop]

task :clean do
  sh 'rm -frv pkg'
end

task :rubocop do
  sh 'rubocop'
end

task :rubocop_dev do
  sh 'rubocop --auto-gen-config'
end
