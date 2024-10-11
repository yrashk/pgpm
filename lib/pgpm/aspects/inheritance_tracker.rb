# frozen_string_literal: true

module Pgpm
  module Aspects
    module InheritanceTracker
      module ClassMethods
        def all_subclasses
          subclasses + subclasses.flat_map(&:all_subclasses)
        end
      end

      def self.included(base_class)
        base_class.extend(ClassMethods)
      end
    end
  end
end
