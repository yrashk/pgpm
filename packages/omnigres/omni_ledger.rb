# frozen_string_literal: true

require "minitar"
require "find"
require "zlib"
require "progress"

module Omnigres
  class OmniLedger < Pgpm::Package
    include Package

    def summary
      "Financial ledgering and accounting"
    end
  end
end
