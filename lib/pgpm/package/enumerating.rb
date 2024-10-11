# frozen_string_literal: true

module Pgpm
  class Package
    module Enumerating
      def self.included(base_class)
        class << base_class
          include Enumerable
          def each(&block)
            if self == Pgpm::Package
              all_subclasses.each(&block)
            else
              package_versions.map { |v| new(v) }.each(&block)
            end
          end
        end
      end
    end
  end
end
