Gem::Specification.new do |s|
  s.name        = 'keepthechange'
  s.version     = '0.3.0'
  s.homepage    = 'https://github.com/pegasd/keepthechange'
  s.summary     = 'Changelog parser'
  s.description = 'Changelog parser (strictly follows keepachangelog.com format)'
  s.license     = 'MIT'

  s.files = Dir['README.md', 'CHANGELOG.md', 'lib/**/*.rb']

  s.add_runtime_dependency 'sem_version', '~> 2.0'

  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'rake', '~> 12.0'
  s.add_development_dependency 'rspec', '~> 3.0'

  s.authors = ['Eugene Piven']
  s.email   = ['thepegasd@gmail.com']
end
