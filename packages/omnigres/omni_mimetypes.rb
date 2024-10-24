# frozen_string_literal: true

module Omnigres
  class OmniMimetypes < Pgpm::Package
    include Package

    def summary
      "MIME types and file extensions"
    end
  end
end
