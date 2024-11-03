# frozen_string_literal: true

module Omnigres
  class OmniVfsTypesV1 < Pgpm::Package
    include Package

    def summary
      "Virtual File System API"
    end

    def native?
      # This extension shares the directory with `omni_vfs` which has .c files,
      # but it is not a native-code extension itself.
      false
    end
  end
end
