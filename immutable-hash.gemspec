
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "immutable/hash/version"

Gem::Specification.new do |spec|
  spec.name          = "immutable-hash"
  spec.version       = Immutable::Hash::VERSION
  spec.authors       = ["Joel Helbling"]
  spec.email         = ["joel@joelhelbling.com"]

  spec.summary       = %q{A Hash-like focused on immutability.}
  spec.description   = %q{A Hash-like focused on immutability.}
  spec.homepage      = "https://github.com/joelhelbling/immutable-hash"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 13.0.1"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec-given"
end
