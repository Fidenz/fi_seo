require_relative 'lib/acts_as_seoable/version'

Gem::Specification.new do |spec|
  spec.name          = 'fi_seo'
  spec.version       = FiSeo::VERSION
  spec.authors       = ['Banura Randika']
  spec.email         = ['info@fidenz.com', 'tech@fidenz.com', 'banura.r@fidenz.com']

  spec.summary       = 'Flexible SEO solution for rails projects'
  spec.description   = 'This gem provides a easier solution to search engine optimization(SEO) in a rails project. This will give you the seo capabilities to your static pages and dynamic pages alike with few lines of code.
                        Also site maps are essential to the SEO of your web application. So this gem gives that capabilities with a feature to integrate google analytics.'
  spec.homepage      = 'https://github.com/fidenz-developer/fi-seo.git'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activerecord', '>= 5.0', '< 6.1'
  spec.add_runtime_dependency 'meta-tags', '~> 2.13'
  spec.add_runtime_dependency 'xml-sitemap', '~> 1.3', '>= 1.3.3'
end
