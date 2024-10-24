# frozen_string_literal: true

module Omnigres
  class OmniHttpd < Pgpm::Package
    include Package

    def summary
      "HTTP web server"
    end

    def build_dependencies
      super + %w[zlib-devel flex bison]
    end

    def depends_on_omni?
      true
    end
  end
end
