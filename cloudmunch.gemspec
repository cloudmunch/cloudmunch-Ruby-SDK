# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloudmunch/version'

Gem::Specification.new do |spec|
  spec.name          = "cloudmunch"
  spec.version       = "0.2.6"
  spec.authors       = ["ganesan krishnamurthy"]
  spec.email         = ["ganesan@cloudmunch.com"]

  spec.summary       = %q{Cloudmunch Ruby SDK.}
  spec.description   = %q{Cloudmunch Ruby SDK to build plugins for cloudmunch platform.}
  spec.homepage      = "https://rubygems.org/gems/cloudmunch"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = Dir.glob("{lib}/**/**")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'json'
  spec.add_dependency 'logger'
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
