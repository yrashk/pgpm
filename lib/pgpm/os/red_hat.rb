# frozen_string_literal: true

require "rbconfig"

module Pgpm
  module OS
    class RedHat < Pgpm::OS::Linux
      def self.auto_detect
        # TODO: distinguish between flavors of RedHat
        RockyEPEL9.new
      end

      def self.name
        "redhat"
      end

      def mock_config; end
    end

    class RockyEPEL9 < Pgpm::OS::RedHat
      def self.name
        "rocky+epel-9"
      end

      def self.builder
        Pgpm::RPM::Builder
      end

      def mock_config
        "rocky+epel-9-#{Pgpm::Arch.in_scope.name}+pgdg"
      end
    end
  end
end
