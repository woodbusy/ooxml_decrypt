Gem::Specification.new do |spec|
  spec.name = 'ooxml_decrypt'
  spec.version = '0.1.0'
  spec.authors = %w[woodbusy phish]
  spec.summary = 'Ruby library and script for decrypting password-protected ' \
                 'Microsoft Office XML files (.docx, .xlsx, etc.)'
  spec.homepage = 'https://github.com/woodbusy/ooxml_decrypt'
  spec.license = 'Apache-2.0'

  spec.files = `git ls-files -z`.split("\x0").reject { |s| s =~ %r{^pkg/} }
  spec.files -= %w[.travis.yml] # Not needed in the gem
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri', '~> 1.10'
  spec.add_dependency 'ruby-ole', '~> 1.2'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '>= 2.11.0', '< 4.0'
end
