# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'puffs'
  spec.version       = '0.2.06'
  spec.authors       = ['Zachary Moroni']
  spec.email         = ['zachary.moroni@gmail.com']

  spec.summary       = %q(A simple ORM and MVC inspired by Rails.)
  spec.description   =
            %q(Make simple apps the Rails way, but with less overhead.)
  spec.homepage      = 'http://github.com/snackzone/puffs'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = 'puffs'

  spec.add_runtime_dependency 'thor', '~> 0.19'
  spec.add_runtime_dependency 'pg', '~> 0.18'
  spec.add_runtime_dependency 'activesupport', '~> 4.2', '>= 4.2.5.1'
  spec.add_runtime_dependency 'pry', '~> 0.10.3'
  spec.add_runtime_dependency 'rack', '~> 1.6', '>= 1.6.4'
  spec.add_runtime_dependency 'fileutils', '~> 0.7'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
