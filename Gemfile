# frozen_string_literal: true

source 'https://rubygems.org'

# Used only for development
group :development do
  gem('debug', '~> 1.11')
  gem('rubocop', '~> 1.75')
  gem('rubocop-ast', '~> 1.4')
  gem('rubocop-performance', '~> 1.10') unless defined?(JRUBY_VERSION)
  gem('rubocop-shopify', '~> 2.0')
  gem('solargraph', '~> 0.48') unless defined?(JRUBY_VERSION)
end
