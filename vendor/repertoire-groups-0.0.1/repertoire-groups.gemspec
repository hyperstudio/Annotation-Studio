require 'rake' # needed for FileList I guess.

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

PKG_FILES = FileList[
  '[a-zA-Z]*',
  'lib/**/*',
  'app/**/*',
  'spec/**/*'
]

# Provide a simple gemspec so you can easily use your
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "repertoire-groups"
  s.summary = "Insert RepertoireGroups summary."
  s.description = "Insert RepertoireGroups description."
  s.files = PKG_FILES.to_a
  s.version = "0.0.1"
  s.authors     = ["Dave Della Costa, Jamie Folsom"]
end