Gem::Specification.new do |gem|
  gem.name    = 'tolk'
  gem.version = '0.0.1'
  gem.date    = Date.today.to_s

  gem.add_dependency 'ya2yaml', '~> 0.29.2'
  # gem.add_development_dependency 'rspec', '~> 1.2.9'

  gem.summary = "Tolk, the Rails translation engine"
  gem.description = "Tolk is a Rails engine designed to facilitate the translators doing the dirty work of translating your application to other languages."

  gem.authors  = ['David Heinemeier Hansson', 'Pratik Naik']
  gem.email    = 'david@loudthinking.com'
  gem.homepage = 'http://github.com/dhh/tolk'

  gem.rubyforge_project = nil
  gem.has_rdoc = true
  gem.rdoc_options = ['--main', 'README', '--charset=UTF-8']
  gem.extra_rdoc_files = ['README', 'MIT-LICENSE']

  gem.files = Dir['Rakefile', '{app,config,db,generators,lib,test}/**/*', 'README*', 'MIT-LICENSE*'] & `git ls-files -z`.split("\0")
end
