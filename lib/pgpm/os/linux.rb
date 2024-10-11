# frozen_string_literal: true

module Pgpm
  module OS
    class Linux < Pgpm::OS::Unix
      def self.auto_detect
        return unless File.exist?("/etc/redhat-release")

        RedHat.auto_detect
      end

      def self.name
        "linux"
      end
    end
  end
end
