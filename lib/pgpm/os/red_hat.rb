# frozen_string_literal: true

require "rbconfig"

module Pgpm
  module OS
    class RedHat < Pgpm::OS::Linux
      def self.auto_detect
        new # TODO: distinguish between flavors of RedHat
      end

      def self.name
        "redhat"
      end
    end

    class RockyEPEL9 < Pgpm::OS::RedHat
      def self.name
        "rocky+epel-9"
      end

      def self.builder
        Pgpm::RPM::Builder
      end

      def initialize(arch: nil)
        @arch = arch || RbConfig::CONFIG["host_cpu"]
        super()
      end

      def mock_config
        "rocky+epel-9-#{@arch}"
      end
    end
  end
end
