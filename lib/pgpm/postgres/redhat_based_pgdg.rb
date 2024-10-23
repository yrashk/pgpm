# frozen_string_literal: true

module Pgpm
  module Postgres
    class RedhatBasedPgdg < Distribution
      def build_time_requirement_packages
        ["postgresql#{major_version} = #{version}",
         "postgresql#{major_version}-devel = #{version}",
         "postgresql#{major_version}-server = #{version}"]
      end

      def requirement_packages
        ["postgresql#{major_version} = #{version}"]
      end

      def pg_config_package
        "postgresql#{major_version}"
      end
    end
  end
end
