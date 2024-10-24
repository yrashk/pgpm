# frozen_string_literal: true

module Omnigres
  class OmniAuth < Pgpm::Package
    include Package

    def summary
      "Authentication framework"
    end

    def build_dependencies
      super + ["zlib-devel", Pgpm::Postgres::Distribution.in_scope.package_for(Pgpm::Contrib::Pgcrypto[:latest])]
    end
  end
end
