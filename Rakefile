require 'rake'
require 'rake/rdoctask'
require 'rake/clean'
require 'spec/rake/spectask'
require 'jeweler'

desc 'Default: run unit tests.'
task :default => :test

Jeweler::Tasks.new do |jewel|
  jewel.name            = 'validate_url'
  jewel.summary         = 'Library for validating urls in Rails.'
  jewel.email           = ['tanel.suurhans@perfectline.ee', 'tarmo.lehtpuu@perfectline.ee']
  jewel.homepage        = 'http://github.com/perfectline/validates_url/tree/master'
  jewel.description     = 'Library for validating urls in Rails.'
  jewel.authors         = ["Tanel Suurhans", "Tarmo Lehtpuu"]
  jewel.files           = FileList["rails/*.rb", "lib/**/*.rb", "*.rb", "MIT-LICENCE", "README.markdown"]

  jewel.add_dependency 'activemodel', '>= 3.0.0'
  jewel.add_development_dependency 'rspec'
  jewel.add_development_dependency 'diff-lcs', '>= 1.1.2'
end

desc 'Generate documentation plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ValidatesUrl'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.markdown')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Run all rspec tests'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.spec_files = FileList["spec/**/*_spec.rb"]
  spec.spec_opts  = ["--options", "spec/spec.opts"]
end