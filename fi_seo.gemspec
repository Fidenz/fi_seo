require_relative 'lib/acts_as_seoable/version'

Gem::Specification.new do |spec|
  spec.name          = 'fi_seo'
  spec.version       = FiSeo::VERSION
  spec.authors       = ['Banura Randika']
  spec.email         = ['banura.r@fidenz.com']

  spec.summary       = 'FI_SEO summary'
  spec.description   = 'FI_SEO description'
  spec.homepage      = 'https://bitbucket.org/fidenz/fi_seo_ror/'
  spec.license       = 'Nonstandard'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activerecord', '~> 5.0', '>= 5.0.0.1'
end
