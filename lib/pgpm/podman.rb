# frozen_string_literal: true

require "English"
require "open3"
require "tty-command"

module Pgpm
  module Podman
    def self.run(command, unhandled_reboot_mitigation: true)
      result = TTY::Command.new(printer: :quiet).run("podman #{command}", pty: true)

      if result.status != 0
        if unhandled_reboot_mitigation && result.err =~ /Please delete/
          FileUtils.rm_rf(["/run/containers/storage", "/run/libpod"])
          run(command, unhandled_reboot_mitigation: false)
        end

        raise StandardError, result.err
      end
      result.out
    end
  end
end
