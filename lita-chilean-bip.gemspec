Gem::Specification.new do |spec|
  spec.name          = 'lita-chilean-bip'
  spec.version       = '1.1.2'
  spec.authors       = ['Emilio Figueroa']
  spec.email         = ['emiliofigueroatorres@gmail.com']
  spec.description   = %q{A Lita handler for checking the BIP card balance}
  spec.summary       = %q{A Lita handler for checking the BIP card balance}
  spec.homepage      = 'https://github.com/milo-ft/lita-chilean-bip'
  spec.license       = 'MIT'
  spec.metadata      = { 'lita_plugin_type' => 'handler' }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lita', '>= 3.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'nokogiri', '~> 1.6.1'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 3.0.0.beta2'
  spec.add_development_dependency 'shoulda', '>= 3.5.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
end
