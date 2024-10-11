# frozen_string_literal: true

require "lspace"

module Pgpm
  module Commands
    class Abstract
      def to_s
        raise "abstract implementation"
      end
    end

    class Make < Abstract
      def initialize(*args)
        @args = args
        super()
      end

      def to_s
        command = "make"
        command += " %{?_smp_mflags}" if Pgpm::OS.in_scope.is_a?(Pgpm::OS::RedHat)
        command += " #{@args.join(" ")}" unless @args.empty?
        command
      end
    end
  end
end
