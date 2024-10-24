# frozen_string_literal: true

module Omnigres
  class Omni < Pgpm::Package
    include Package

    def summary
      "Advanced adapter for Postgres extensions"
    end
  end
end
