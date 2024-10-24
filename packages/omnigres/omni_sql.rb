# frozen_string_literal: true

module Omnigres
  class OmniSql < Pgpm::Package
    include Package

    def summary
      "Programmatic access to SQL"
    end
  end
end
