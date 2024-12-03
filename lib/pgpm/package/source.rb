# frozen_string_literal: true

module Pgpm
  class Package
    module Source
      def source
        raise StandardError, "no source specified"
      end

      def sources
        []
      end
    end
  end
end
