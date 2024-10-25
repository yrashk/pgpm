# frozen_string_literal: true

require "open-uri"
require "nokogiri"
require "lspace"

module Pgpm
  module Postgres
    class Distribution
      attr_reader :version

      def initialize(postgres_version)
        @version = postgres_version
      end

      def build_time_requirement_packages
        raise NotImplementedError
      end

      def major_version
        @version.split(".").first.to_i
      end

      def minor_version
        @version.split(".")[1].to_i
      end

      def with_scope(&block)
        LSpace.with(pgpm_target_postgres: self) do
          block.yield
        end
      end

      def self.in_scope
        LSpace[:pgpm_target_postgres]
      end

      def self.versions
        return @versions if @versions

        versions_rss = Nokogiri::XML(URI.open("https://www.postgresql.org/versions.rss"))
        @versions = versions_rss.search("description").map do |ver|
          maj, min = ver.content.split(" ").first.split(".")
          if "#{maj}.#{min}" =~ /\d+\.\d+/
            Pgpm::Package::Version.new("#{maj}.#{min}")
          end
        end.compact.sort.reverse.group_by(&:major).map do |(major, group)|
          minor_versions = group.map(&:minor)
          full_minor_range = (0..minor_versions.max)
          missing_minors = full_minor_range.to_a - minor_versions
          filled_versions = []
          missing_minors.each do |minor|
            filled_versions << Pgpm::Package::Version.new("#{major}.#{minor}")
          end

          filled_versions.concat(group).reverse
        end.flatten.reverse
      end
    end
  end
end
