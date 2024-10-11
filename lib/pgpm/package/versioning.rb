# frozen_string_literal: true

module Pgpm
  class Package
    module Versioning
      module ClassMethods
        def package_versions
          warn("No versions defined for #{package_name}")
          []
        end

        def package_versioning_scheme
          @package_versioning_scheme ||= :semver
        end

        def versioning_scheme(scheme)
          @package_versioning_scheme = scheme
        end
      end

      def self.included(base_class)
        base_class.extend(ClassMethods)
      end

      attr_reader :version
    end
  end
end
