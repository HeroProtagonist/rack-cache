Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.name = 'rack-cache'
  s.version = '0.1'
  s.date = "2008-05-02"

  s.description = "Caching middleware for Rack"
  s.summary     = "Caching middleware for Rack"

  s.authors = ["Ryan Tomayko"]
  s.email = "r@tomayko.com"

  # git ls-files | grep -v '^\.'
  s.files = %w[
    COPYING
    README.markdown
    Rakefile
    lib/rack/cache.rb
    lib/rack/cache/config.rb
    lib/rack/cache/config/breakers.rb
    lib/rack/cache/config/default.rb
    lib/rack/cache/context.rb
    lib/rack/cache/core.rb
    lib/rack/cache/headers.rb
    lib/rack/cache/options.rb
    lib/rack/cache/request.rb
    lib/rack/cache/response.rb
    lib/rack/cache/storage.rb
    lib/rack/utils/environment_headers.rb
    rack-cache.gemspec
    test/cache_test.rb
    test/config_test.rb
    test/context_test.rb
    test/core_test.rb
    test/headers_test.rb
    test/options_test.rb
    test/response_test.rb
    test/spec_setup.rb
    test/storage_test.rb
  ]

  s.test_files = s.files.select {|path| path =~ /^test\/.*_test.rb/}

  s.extra_rdoc_files = %w[COPYING]
  s.add_dependency 'rack', '>= 0.3.0'

  s.has_rdoc = true
  s.homepage = "http://github.com/rtomayko/rack-cache"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Rack::Cache", "--main", "Rack::Cache"]
  s.require_paths = %w[lib]
  s.rubyforge_project = 'wink'
  s.rubygems_version = '1.1.1'
end