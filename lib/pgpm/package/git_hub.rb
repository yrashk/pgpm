# frozen_string_literal: true

require "open-uri"

module Pgpm
  class Package
    module GitHub
      Config = Data.define(:name, :download_version_tags)

      def sources
        commit = version_git_tag || version_git_commit
        [Pgpm::OnDemandFile.new("#{version}.tar.gz", lambda {
          URI.open("https://github.com/#{self.class.github_config.name}/archive/#{commit}.tar.gz")
        })] + super
      end

      module ClassMethods
        attr_reader :github_config

        def github(name, download_version_tags: true)
          @github_config = Config.new(name:, download_version_tags:)
          include Pgpm::Package::Git
          git "https://github.com/#{@github_config.name}", download_version_tags:
        end
      end

      def self.included(base_class)
        base_class.extend(ClassMethods)
      end
    end
  end
end
