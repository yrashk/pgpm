# frozen_string_literal: true

require "semver_dialects"

class PlpgsqlCheck < Pgpm::Package
  github "okbob/plpgsql_check"

  def build_steps
    if pg_config_hardcoded?
      export_pg_config_to_path + super
    else
      super
    end
  end

  def install_steps
    if pg_config_hardcoded?
      export_pg_config_to_path + super
    else
      super
    end
  end

  private

  def pg_config_hardcoded?
    # https://github.com/okbob/plpgsql_check/pull/179
    version <= "2.7.12"
  end

  def export_pg_config_to_path
    ["export PATH=$(dirname $PG_CONFIG):$PATH"]
  end
end
