# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tddium_status/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Mick Staugaard']
  gem.email         = ['mick@staugaard.com']
  gem.description   = "A library (and CLI) for getting the status of your tddium builds"
  gem.summary       = "Easy access to the status of your tddium builds"
  gem.homepage      = ''

  gem.files         = Dir.glob('{bin,lib,test}/**/*') + ['README.md']
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'tddium_status'
  gem.require_paths = ['lib']
  gem.version       = TddiumStatus::VERSION

  gem.add_dependency 'rainbow'
end
