require 'bundler/setup'
require 'rubygems'
require 'simplecov'
SimpleCov.profiles.delete(:root_filter)
SimpleCov.filters.clear
SimpleCov.start 'rails' do
  add_filter do |src|
    !(src.filename =~ /^#{SimpleCov.root}/) unless src.filename =~ /\/src\//
  end
end
require "test/unit"
