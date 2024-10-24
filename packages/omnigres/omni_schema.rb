# frozen_string_literal: true

module Omnigres
  class OmniSchema < Pgpm::Package
    include Package

    def summary
      "Application schema management"
    end
  end
end
