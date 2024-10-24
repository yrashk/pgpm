# frozen_string_literal: true

module Omnigres
  class OmniManifest < Pgpm::Package
    include Package

    def summary
      "Improved extension installation"
    end
  end
end
