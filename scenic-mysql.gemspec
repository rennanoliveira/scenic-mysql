# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scenic/mysql/version'

Gem::Specification.new do |spec|
  spec.name          = 'scenic-mysql'
  spec.version       = Scenic::Mysql::VERSION
  spec.authors       = ['Rennan Oliveira', 'Abraão Miranda']
  spec.email         = ['renmcoliver@gmail.com', 'abraaomirandar@gmail.com']

  spec.summary       = %q{Mysql adapter for the scenic gem}
  spec.description   = %q{Adds Mysql adapter to the scenic gem}
  spec.homepage      = 'https://github.com/rennanoliveira/scenic-mysql'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 1.5'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 3.3'
  spec.add_development_dependency 'mysql2', '>= 0.4.4'
  spec.add_development_dependency 'pry'

  spec.add_dependency 'scenic', '>= 1.3'

end
