# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# PKG_FILES = FileList[
#   '[a-zA-Z]*',
#   'lib/**/*',
#   'app/**/*',
#   'spec/**/*'
# ]

# Provide a simple gemspec so you can easily use your
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "repertoire-groups"
  s.summary = "Insert RepertoireGroups summary."
  s.description = "Insert RepertoireGroups description."
  # s.files = PKG_FILES.to_a
  s.files = `git ls-files -z`.split("\x0")
  s.version = "0.0.1"
  s.authors     = ["Dave Della Costa, Jamie Folsom"]
end