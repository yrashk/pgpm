# frozen_string_literal: true

module Omnigres
  class OmniContainers < Pgpm::Package
    include Package

    def summary
      "Managing containers"
    end

    def build_dependencies
      super + ["zlib-devel"]
    end
  end
end
