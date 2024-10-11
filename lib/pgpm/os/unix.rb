# frozen_string_literal: true

module Pgpm
  module OS
    class Unix < Pgpm::OS::Base
      def self.name
        "unix"
      end
    end
  end
end
