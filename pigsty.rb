#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/setup"
require "active_support/core_ext/string/inflections"
require "pgpm"
require "csv"
require "open-uri"

URI.open("https://raw.githubusercontent.com/pgsty/extension/refs/heads/main/data/pigsty.csv") do |f|
  i = 0
  CSV.foreach(f, headers: true) do |row|
    origin = row["url"].downcase
    next unless origin =~ /https?:\/\/(github|gitlab)\.com\//
    source = $1
    namespace, project = origin.match(%r{https://#{source}\.com/([^/]+)/([^/]+)}).captures
    namespace = namespace.downcase
    origin = "#{source == "github" ? "github" : "git"} \"#{namespace}/#{project}\""
    filename = "packages/#{namespace}/#{project}.rb"
    next if File.exist?(filename) || File.exist?("packages/#{project}.rb")
    name = row["name"]
    if namespace
      dir = "packages/#{namespace}"
      Dir.mkdir(dir) if !Dir.exist?(dir)
    end

    i += 1
    classname = name.camelize
    new_class = <<~CLASS
      # frozen_string_literal: true

      class #{namespace ? "#{namespace.camelize}::#{classname}" : classname} < Pgpm::Package
        #{origin}

        def self.package_name
          "#{name}"
        end

        def summary
          "#{row["en_desc"]}"
        end

        def description
          "#{row["en_desc"]}"
        end

        def license
          "#{row["license"]}"
        end
      end
    CLASS
    File.write(filename, new_class)
    puts name
  end
  puts "#{i} packages imported"
end
