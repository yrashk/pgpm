# frozen_string_literal: true

module Pgpm
  class Package
    module Contrib
      def contrib?
        self.class.instance_variable_get(:@contrib)
      end

      module ClassMethods
        def contrib_package
          @contrib = true
        end

        def package_name(exclude_namespace: false)
          if contrib?
            super(exclude_namespace: true)
          else
            super
          end
        end

        def contrib?
          @contrib
        end

        def package_versions
          if contrib?
            Class.new do
              include Enumerable

              def include?(_version)
                true
              end

              def empty?
                false
              end

              def each
                yield "*"
              end
            end.new
          else
            super
          end
        end
      end

      def self.included(base_class)
        base_class.extend(ClassMethods)
      end
    end
  end
end
