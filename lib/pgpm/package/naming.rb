# frozen_string_literal: true

module Pgpm
  class Package
    module Naming
      module ClassMethods
        def package_name
          class_name = to_s.split("::").last
          @name || Dry::Inflector.new.underscore(class_name)
        end

        protected

        def name(name)
          @name = name
        end
      end

      def self.included(base_class)
        base_class.extend(ClassMethods)
      end

      def name
        self.class.package_name
      end

      def extension_name
        name
      end
    end
  end
end
