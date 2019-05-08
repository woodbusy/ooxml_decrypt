lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ooxml_decrypt/version"

Gem::Specification.new do |spec|
  spec.name = 'ooxml_decrypt'
  spec.version = OoxmlDecrypt::VERSION
  spec.authors = %w[woodbusy phish]
  spec.summary = 'Ruby library and script for decrypting password-protected ' \
                 'Microsoft Office XML files (.docx, .xlsx, etc.)'
  spec.homepage = 'https://github.com/woodbusy/ooxml_decrypt'
  spec.license = 'Apache-2.0'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(bin|spec)/}) }
  end
  spec.files -= %w[.travis.yml] # Not needed in the gem
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri', '~> 1.10'
  spec.add_dependency 'ruby-ole', '~> 1.2'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '>= 2.11.0', '< 4.0'
end
