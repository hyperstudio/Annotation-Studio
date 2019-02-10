lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name = "repertoire-groups"
  s.summary = "Insert RepertoireGroups summary."
  s.description = "Insert RepertoireGroups description."
  s.files = Dir['[a-zA-Z]*'] + Dir['lib/**/*']+Dir['app/**/*']+Dir['spec/**/*']
  s.files.reject! { |fn| fn.include? "CVS" }
  s.version = "0.0.1"
  s.authors     = ["Dave Della Costa, Jamie Folsom"]
end
