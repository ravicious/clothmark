require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "clothmark"
    gem.summary = %Q{With ClothMark you can easily convert your files formatted with Markdown, Textile or BBCode to HTML files.}
    gem.description = %Q{With ClothMark you can easily convert your files formatted with Markdown, Textile or BBCode to HTML files.}
    gem.email = "ravicious@gmail.com"
    gem.homepage = "http://github.com/ravicious/clothmark"
    gem.authors = ["Rafal Cieslak"]
    gem.files = FileList['lib/**/*.rb', 'bin/*', '[A-Z]*', 'spec/**/*'].to_a
    gem.add_dependency('bb-ruby', '>=0.9.3')
    gem.add_dependency('BlueCloth', '>=1.0.0')
    gem.add_dependency('RedCloth', '>=4.2.2')
    gem.executables = ['clothmark']
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.spec_opts = %w(-fs)
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
  spec.rcov_opts = ['--exclude', "spec"]
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ClothMark #{version}"
  rdoc.rdoc_files.include('README*', 'LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
