# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'newrelic_sidekiq_agent'

Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '2.2.2'
  s.required_ruby_version = '>= 1.9.3'

  s.name              = 'newrelic_sidekiq_plugin'
  s.version           = NewRelicSidekiqPlugin::VERSION
  s.license           = 'MIT'

  s.summary     = "New Relic plugin for reporting Sidekiq statistics"
  s.description = "New Relic plugin for reporting Sidekiq statistics"

  s.authors  = ["Jesse Szwedko"]
  s.email    = 'j.szwedko@modcloth.com'
  s.homepage = 'https://github.com/modcloth/newrelic_sidekiq_plugin'

  all_files       = `git ls-files -z`.split("\x0")
  s.files         = all_files.grep(%r{^(bin|lib)/})
  s.executables   = all_files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.rdoc_options = ["--charset=UTF-8"]

  s.add_runtime_dependency('newrelic_plugin', "~> 1.3.1")
  s.add_runtime_dependency('sidekiq', "~> 3.1.4")
end
