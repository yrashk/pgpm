# frozen_string_literal: true

require "semver_dialects"

module Pgpm
  module Postgres
    class Distribution
      def initialize(postgres_version)
        @postgres_version = postgres_version
      end

      def build_time_requirement_packages
        raise NotImplementedError
      end
    end

    class RedhatBasedPGDG < Distribution
      def build_time_requirement_packages
        version = SemverDialects.parse_version("cargo", @postgres_version)
        major = version.tokens.first
        ["postgresql#{major}-#{version}-", "postgresql17-"]
      end
    end
  end
end
