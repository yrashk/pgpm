# frozen_string_literal: true

module Pgpm
  module RPM
    class Builder
      def initialize(spec)
        @spec = spec
      end

      def source_builder(target_directory = nil)
        target_directory ||= "."
        dir = Dir.mktmpdir("pgpm")
        File.open(Pathname(dir).join("#{safe_package_name}.spec"), "w") do |specfile|
          specfile.write(@spec.to_s)
          specfile.close
          sources = File.join(dir, "sources")
          FileUtils.mkdir_p(sources)
          @spec.sources.map do |src|
            print "Downloading #{src.name}..."
            srcfile = File.join(sources, src.name)
            File.write(srcfile, src.read)
            puts " done."
          end
          cfg = Pgpm::RPM::Mock::Config.new(Pgpm::OS.in_scope.mock_config)
          Pgpm::RPM::Mock::Operation.buildsrpm(specfile.path, sources, config: cfg.path, result_dir: target_directory, cb: lambda {
            FileUtils.rm_rf(dir)
          })
        end
      end

      def versionless_builder(target_directory = nil)
        target_directory ||= "."
        dir = Dir.mktmpdir("pgpm")
        File.open(Pathname(dir).join("#{safe_package_name}.spec"), "w") do |specfile|
          specfile.write(@spec.versionless)
          specfile.close
          cfg = Pgpm::RPM::Mock::Config.new(Pgpm::OS.in_scope.mock_config)
          Pgpm::RPM::Mock::Operation.buildsrpm(specfile.path, nil, config: cfg.path, result_dir: target_directory, cb: lambda {
            FileUtils.rm_rf(dir)
          })
        end
      end

      def self.builder(srpm)
        target_directory ||= "."
        cfg = Pgpm::RPM::Mock::Config.new(Pgpm::OS.in_scope.mock_config)
        srpm = [srpm] if srpm.is_a?(String)
        srpm.reduce(nil) do |b, rpm|
          op = Pgpm::RPM::Mock::Operation.rebuild(rpm, config: cfg.path, result_dir: target_directory)
          b.nil? ? op : b.chain(op)
        end
      end

      private

      def safe_package_name
        @spec.package.name.gsub(%r{/}, "__")
      end
    end
  end
end
