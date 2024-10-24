# frozen_string_literal: true

module Omnigres
  class OmniSeq < Pgpm::Package
    include Package

    def summary
      "Extended Postgres sequence tooling"
    end
  end
end
