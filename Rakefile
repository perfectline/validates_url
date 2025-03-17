require 'rake'
require 'rdoc/task'
require 'rake/clean'
require 'rspec/core/rake_task'
require 'jeweler'

desc 'Default: run unit tests.'
task default: :test

Jeweler::Tasks.new do |jewel|
  jewel.name            = 'validate_url'
  jewel.summary         = 'Library for validating urls in Rails.'
  jewel.email           = ['tanel.suurhans@perfectline.co', 'tarmo.lehtpuu@perfectline.co', 'vladimir.krylov@perfectline.co']
  jewel.homepage        = 'http://github.com/perfectline/validates_url/tree/master'
  jewel.description     = 'Library for validating urls in Rails.'
  jewel.authors         = ["Tanel Suurhans", "Tarmo Lehtpuu", "Vladimir Krylov"]
  jewel.license         = 'MIT'
  jewel.files           = FileList["lib/**/*.rb", "lib/locale/*.yml", "*.rb", "LICENSE.md", "README.md"]

  jewel.add_dependency 'activemodel', '>= 3.0.0'
  jewel.add_dependency 'public_suffix'
  jewel.add_development_dependency 'rspec'
  jewel.add_development_dependency 'diff-lcs', '>= 1.1.2'
end

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
