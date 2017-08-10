# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "apisync/version"

Gem::Specification.new do |spec|
  spec.name          = "apisync"
  spec.version       = Apisync::VERSION
  spec.authors       = ["Alexandre de Oliveira"]
  spec.email         = ["alex@veiculo.online"]

  spec.summary       = %q{Official client to apisync.io}
  spec.homepage      = "https://github.com/apisync/apisync-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
