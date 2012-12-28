# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hokuto/version'

Gem::Specification.new do |gem|
  gem.name          = "hokuto"
  gem.version       = Hokuto::VERSION
  gem.authors       = ["Kevin TOYODA"]
  gem.email         = ["condor1226@gmail.com"]
  gem.description   = %q{A lightweight application server for simple ruby web applications.}
  gem.summary       = <<-EOF
  Hokuto: A lightweight web application server for simple ruby web applications depending on rack.
  EOF
  gem.homepage      = "https://github.com/condor/hokuto"
  gem.add_dependency 'jruby-rack'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
