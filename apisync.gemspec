# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "apisync/version"

Gem::Specification.new do |spec|
  spec.name          = "apisync"
  spec.version       = Apisync::VERSION
  spec.authors       = ["Alexandre de Oliveira"]
  spec.email         = ["chavedomundo@gmail.com"]

  spec.summary       = %q{Official client to apisync.io}
  spec.homepage      = "https://github.com/apisync/apisync-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.13"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "webmock"
end
