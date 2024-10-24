# frozen_string_literal: true

module Omnigres
  class OmniOs < Pgpm::Package
    include Package

    def summary
      "Access to the operating system"
    end
  end
end
