# frozen_string_literal: true

require "semver_dialects"

module Pgpm
  class Package
    module Subscripting
      module ClassMethods
        def [](name)
          if self == Pgpm::Package
            all_subclasses.find { |klass| klass.package_name == name }
          elsif name == :latest && package_versioning_scheme == :semver
            return nil if package_versions.empty?

            version = package_versions.map { |ver| ver.is_a?(Pgpm::Package::Version) ? ver : Pgpm::Package::Version.new(ver) }.max
            new(Pgpm::Package::Version.new(version.to_s))
          elsif name == :latest
            null
          elsif package_versions.include?(name)
            new(Pgpm::Package::Version.new(name.to_s))
          else
            all_subclasses.find { |klass| klass.package_name == name }
          end
        end
      end

      def self.included(base_class)
        base_class.extend(ClassMethods)
      end
    end
  end
end
