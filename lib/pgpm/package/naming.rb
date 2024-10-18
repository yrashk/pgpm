# frozen_string_literal: true

module Pgpm
  class Package
    module Naming
      module ClassMethods
        def package_name(exclude_namespace: false)
          modules = to_s.split("::")
          class_name = modules.last
          name = @name || Dry::Inflector.new.underscore(class_name)
          if exclude_namespace
            name
          else
            namespace = modules[..-2].map { |m| Dry::Inflector.new.underscore(m) }.join("/")
            namespace += "/" unless namespace.empty?
            namespace + name
          end
        end

        protected

        def name(name)
          @name = name
        end
      end

      def self.included(base_class)
        base_class.extend(ClassMethods)
      end

      def name(exclude_namespace: true)
        self.class.package_name(exclude_namespace:)
      end

      def extension_name
        name
      end
    end
  end
end
