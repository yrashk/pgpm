# frozen_string_literal: true

module Omnigres
  class OmniHttpc < Pgpm::Package
    include Package

    def summary
      "HTTP client"
    end

    def build_dependencies
      super + ["zlib-devel"]
    end
  end
end
