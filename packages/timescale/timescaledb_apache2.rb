# frozen_string_literal: true

module Timescale
  # TODO: do we want this "subpackage" to be some kind of "flavour" in pgpm?
  class TimescaledbApache2 < Timescaledb
    # TODO: can pgpm handle subclassing here better?
    github "timescale/timescaledb"

    def extension_name
      "timescaledb"
    end

    def source_url_directory_name
      "timescaledb-2.17.2"
    end

    def license
      "Apache 2.0"
    end

    protected

    def bootstrap_flags
      ["APACHE_ONLY=1"]
    end
  end
end
