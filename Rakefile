require 'rake'
require 'rdoc/task'
require 'rake/clean'
require 'rspec/core/rake_task'

desc 'Default: run unit tests.'
task default: :test

desc 'Generate documentation plugin.'
RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ValidatesUrl'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Run all rspec tests'
RSpec::Core::RakeTask.new(:test)
