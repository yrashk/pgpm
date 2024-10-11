# frozen_string_literal: true

module Pgpm
  class Package
    module Metadata
      def summary
        self.class.summary
      end

      def description
        self.class.description
      end

      def all_searchable_texts
        self.class.all_searchable_texts
      end

      def license
        self.class.license
      end

      module ClassMethods
        def summary
          "TODO: Summary"
        end

        def description
          "TODO: Description"
        end

        def license
          "TODO: License"
        end

        def all_searchable_texts
          [package_name, summary, description]
        end
      end

      def self.included(base_class)
        base_class.extend(ClassMethods)
      end
    end
  end
end
