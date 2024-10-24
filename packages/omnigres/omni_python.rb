# frozen_string_literal: true

module Omnigres
  class OmniPython < Pgpm::Package
    include Package

    def summary
      "First-class Python Development Experience"
    end

    def build_dependencies
      super + [Pgpm::Postgres::Distribution.in_scope.package_for(Pgpm::Contrib::Plpython3u[:latest])]
    end
  end
end
