# frozen_string_literal: true

class Pgsodium < Pgpm::Package
  github "michelp/pgsodium"

  def build_dependencies
    super + ["libsodium-devel >= 1.0.18"]
  end

  def dependencies
    super + ["libsodium >= 1.0.18"]
  end

  def broken?
    version >= "3.0.0" && Pgpm::Postgres::Distribution.in_scope.major_version < 14
  end
end
