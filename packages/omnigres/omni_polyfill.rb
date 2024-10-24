# frozen_string_literal: true

module Omnigres
  class OmniPolyfill < Pgpm::Package
    include Package

    def summary
      "Provides polyfills for older versions of Postgres"
    end
  end
end
