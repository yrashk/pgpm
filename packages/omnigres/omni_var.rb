# frozen_string_literal: true

module Omnigres
  class OmniVar < Pgpm::Package
    include Package

    def summary
      "Variable management"
    end
  end
end
