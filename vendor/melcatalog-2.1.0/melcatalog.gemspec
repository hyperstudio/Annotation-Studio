# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'melcatalog/version'

Gem::Specification.new do |spec|
  spec.name          = "melcatalog"
  spec.version       = Melcatalog::VERSION
  spec.authors       = ["Dave Goldstein"]
  spec.email         = ["dave@performantsoftware.com"]
  spec.summary       = %q{Provides access to the MEL catalogue API}
  spec.description   = %q{Provides a gem abstraction layer to the MEL catalogue service}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.3'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rest-client', '1.7.2'
end
