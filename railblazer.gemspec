# -*- encoding: utf-8 -*-
require File.expand_path('../lib/railblazer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Justin S. Leitgeb"]
  gem.email         = ["justin@stackbuilders.com"]
  gem.summary       = %q{Tools to automate builds for Stack Builders CI server}
  gem.description   = <<-EOS
    Contains tools to automate the build for the Stack Builders CI server.
    Includes
  EOS

  gem.homepage      = "http://github.com/stackbuilders/railblazer"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "railblazer"
  gem.require_paths = ["lib"]
  gem.version       = Railblazer::VERSION
end
