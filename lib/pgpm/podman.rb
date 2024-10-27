# frozen_string_literal: true

require "English"

module Pgpm
  module Podman
    def self.run(command, unhandled_reboot_mitigation: true)
      output = `podman #{command} 2>&1`
      if $CHILD_STATUS.exitstatus != 0
        raise StandardError, output unless unhandled_reboot_mitigation && output =~ /Please delete directories/

        FileUtils.rm_rf(["/run/containers/storage", "/run/libpod"])
        run(command, unhandled_reboot_mitigation: false)

      end
      output
    end
  end
end
