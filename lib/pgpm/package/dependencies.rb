# frozen_string_literal: true

module Pgpm
  class Package
    module Dependencies
      def build_dependencies
        return ["gcc"] if c_files_present?

        []
      end

      def dependencies
        []
      end

      def c_files_present?
        Dir.glob("*.c", base: source).any?
      end
    end
  end
end
