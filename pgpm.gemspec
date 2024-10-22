# frozen_string_literal: true

require_relative "lib/pgpm/version"

Gem::Specification.new do |spec|
  spec.name = "pgpm"
  spec.version = Pgpm::VERSION
  spec.authors = ["Yurii Rashkovskii"]
  spec.email = ["yrashk@gmail.com"]

  spec.summary = "Postgres Package Manager"
  spec.homepage = "https://postgres.pm"
  spec.license = "Apache-2.0"
  spec.required_ruby_version = ">= 3.3.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/postgres-pm/postgres-om"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  spec.add_dependency "dry-cli", "~> 1.1.0"
  spec.add_dependency "dry-inflector", "~> 1.1.0"
  spec.add_dependency "git", "~> 2.3.0"
  spec.add_dependency "lspace", "~> 0.14"
  spec.add_dependency "minitar", "~> 1.0.2"
  spec.add_dependency "oj", "~> 3.16.6"
  spec.add_dependency "parallel", "~> 1.26.3"
  spec.add_dependency "perfect_toml", "~> 0.9.0"
  spec.add_dependency "progress", "~> 3.6.0"
  spec.add_dependency "semver_dialects", "~> 3.4.3"
  spec.add_dependency "xdg", "~> 8.7.0"
  spec.add_dependency "zeitwerk", "~> 2.6.18"
  spec.add_dependency "zlib", "~> 3.1.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
