# frozen_string_literal: true

module Omnigres
  class OmniSession < Pgpm::Package
    include Package

    def summary
      "Session management"
    end

    def build_dependencies
      super + %w[zlib-devel flex bison]
    end
  end
end
