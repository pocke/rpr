# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rpr/version'

Gem::Specification.new do |spec|
  spec.name          = "rpr"
  spec.version       = Rpr::VERSION
  spec.authors       = ["Masataka Kuwabara"]
  spec.email         = ["p.ck.t22@gmail.com"]

  spec.summary       = %q{RPR displays Ruby's AST on command line.}
  spec.description   = %q{RPR displays Ruby's AST on command line.}
  spec.homepage      = "https://github.com/pocke/rpr"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.licenses = ['CC0-1.0']

  spec.add_runtime_dependency 'pry', '~> 0.10.3'
  spec.add_runtime_dependency 'rubocop', '~> 0.40.0'
  spec.add_runtime_dependency 'parser', '~> 2.3.1.0'
  spec.add_runtime_dependency 'ruby_parser', '~> 3.8.3'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"

  # testing
  spec.add_development_dependency "minitest", "~> 5.9.0"
  spec.add_development_dependency "minitest-power_assert", "~> 0.2.0"
  spec.add_development_dependency 'guard', '~> 2.13.0'
  spec.add_development_dependency 'guard-minitest', '~> 2.4.4'
  spec.add_development_dependency 'guard-bundler', '~> 2.1.0'
  spec.add_development_dependency 'coveralls', '~> 0.8.13'
  spec.add_development_dependency 'simplecov', '~> 0.11.0'
end
