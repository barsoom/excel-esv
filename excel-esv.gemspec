# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'esv/version'

Gem::Specification.new do |spec|
  spec.name          = "excel-esv"
  spec.version       = ESV::VERSION
  spec.authors       = ["Henrik Nyh"]
  spec.email         = ["henrik@nyh.se"]
  spec.summary       = %q{Excel parsing and generation with the ease of CSV.}
  spec.homepage      = "https://github.com/barsoom/excel-esv"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "spreadsheet"
  spec.add_development_dependency "bundler", ">= 1.7"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "rspec"
end
