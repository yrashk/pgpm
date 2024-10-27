# frozen_string_literal: true

module Pgpm
  class Package
    module Make
      def build_steps
        return [Pgpm::Commands::Make.new("PG_CONFIG=$PG_CONFIG")] if makefile_present?

        super
      end

      def install_steps
        return [Pgpm::Commands::Make.new("install", "DESTDIR=$PGPM_BUILDROOT", "PG_CONFIG=$PG_CONFIG")] if makefile_present?

        super
      end

      def makefile_present?
        !Dir.glob(%w[Makefile GNUmakefile makefile], base: source.to_s).empty?
      end
    end
  end
end
