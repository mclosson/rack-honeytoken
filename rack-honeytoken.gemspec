# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/honeytoken/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-honeytoken"
  spec.version       = Rack::Honeytoken::VERSION
  spec.license       = ["BSD-2-Clause"]
  spec.authors       = ["Matthew Closson"]
  spec.email         = ["matthew.closson@gmail.com"]

  spec.summary       = %q{Rack middleware honeytokens implementation.}
  spec.description   = %q{Define, detect and take action on honeytokens in web responses as rack middleware.}
  spec.homepage      = "https://github.com/mclosson/rack-honeytoken"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rack-test"
end
