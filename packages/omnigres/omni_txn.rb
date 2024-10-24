# frozen_string_literal: true

module Omnigres
  class OmniTxn < Pgpm::Package
    include Package

    def summary
      "Advanced transaction management"
    end
  end
end
