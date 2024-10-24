# frozen_string_literal: true

module Omnigres
  class OmniAws < Pgpm::Package
    include Package

    def summary
      "AWS APIs"
    end

    def build_dependencies
      super + ["zlib-devel", Pgpm::Postgres::Distribution.in_scope.package_for(Pgpm::Contrib::Pgcrypto[:latest])]
    end
  end
end
