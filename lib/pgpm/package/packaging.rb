# frozen_string_literal: true

module Pgpm
  class Package
    module Packaging
      def to_rpm_spec(**opts)
        Pgpm::RPM::Spec.new(self, **opts)
      end
    end
  end
end
