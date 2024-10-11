# frozen_string_literal: true

module Pgpm
  class Package
    module AbstractPackage
      module ClassMethods
        def abstract_package?
          @is_abstract_package || false
        end

        protected

        def abstract_package
          @is_abstract_package = true
        end
      end

      def self.included(base_class)
        base_class.extend(ClassMethods)
      end
    end
  end
end
