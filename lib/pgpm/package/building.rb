# frozen_string_literal: true

module Pgpm
  class Package
    module Building
      def configure_steps
        []
      end

      def build_steps
        return [Pgpm::Commands::Make.new] if makefile_present?

        []
      end

      def install_steps
        return [Pgpm::Commands::Make.new("install", "DESTDIR=$PGPM_BUILDROOT")] if makefile_present?

        []
      end

      def makefile_present?
        !Dir.glob(%w[Makefile GNUmakefile makefile], base: source.to_s).empty?
      end

      def source_url_directory_name
        nil
      end
    end
  end
end
