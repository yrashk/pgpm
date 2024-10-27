# frozen_string_literal: true

require "English"
require "open3"

module Pgpm
  module Podman
    def self.run(command, unhandled_reboot_mitigation: true)
      system("podman #{command}")

      if $CHILD_STATUS.exitstatus != 0
        raise StandardError, errors unless unhandled_reboot_mitigation

        FileUtils.rm_rf(["/run/containers/storage", "/run/libpod"])
        run(command, unhandled_reboot_mitigation: false)

      end
      output
    end
  end
end
