require File.expand_path('../lib/speci/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Pavel Evstigneev"]
  gem.email         = ["pavel.evst@gmail.com"]
  gem.description   = gem.summary = "Continiusly rspec runner"
  #gem.homepage      = "http://"
  gem.license       = "LGPL-3.0"

  gem.executables   = ['speci']
  gem.files         = `git ls-files | grep -Ev '^(myapp|examples)'`.split("\n")
  #gem.test_files    = `git ls-files -- test/*`.split("\n")
  gem.name          = "speci"
  gem.require_paths = ["lib"]
  gem.version       = Speci::VERSION
  gem.add_dependency 'listen', "~> 1.3.0"
  gem.add_dependency 'rb-fsevent', "~> 0.9.3"
  gem.add_dependency 'rb-readline', "~> 0.5.0"
end