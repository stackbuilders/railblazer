# -*- encoding: utf-8 -*-
require File.expand_path('../lib/railblazer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Justin S. Leitgeb"]
  gem.email         = ["justin@stackbuilders.com"]
  gem.summary       = %q{Quick Rails app configuration}
  gem.description   = %q{Automatically configures Rails database connection for development and CI server}

  gem.homepage      = "http://github.com/stackbuilders/railblazer"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^spec/})

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'mocha', '~> 0.10.5'

  gem.name          = "railblazer"
  gem.require_paths = ["lib"]
  gem.version       = Railblazer::VERSION
end
