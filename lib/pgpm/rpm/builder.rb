# frozen_string_literal: true

module Pgpm
  module RPM
    class Builder
      def initialize(spec, os: nil)
        @spec = spec
        @os = os || Pgpm::OS.auto_detect
      end

      def source_builder(target_directory = nil)
        target_directory ||= "."
        @os.with_scope do
          dir = Dir.mktmpdir("pgpm")
          File.open(Pathname(dir).join("#{@spec.package.name}.spec"), "w") do |specfile|
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
            cfg = Pgpm::RPM::Mock::Config.new(@os.mock_config, path: target_directory)
            Pgpm::RPM::Mock::Operation.buildsrpm(specfile.path, sources, config: cfg.path, result_dir: target_directory, cb: lambda {
              FileUtils.rm_rf(dir)
            })
          end
        end
      end

      def versionless_builder(target_directory = nil)
        target_directory ||= "."
        @os.with_scope do
          dir = Dir.mktmpdir("pgpm")
          File.open(Pathname(dir).join("#{@spec.package.name}.spec"), "w") do |specfile|
            specfile.write(@spec.versionless)
            specfile.close
            cfg = Pgpm::RPM::Mock::Config.new(@os.mock_config, path: target_directory)
            Pgpm::RPM::Mock::Operation.buildsrpm(specfile.path, nil, config: cfg.path, result_dir: target_directory, cb: lambda {
              FileUtils.rm_rf(dir)
            })
          end
        end
      end

      def self.builder(srpm, os: nil)
        os ||= Pgpm::OS.auto_detect
        os.with_scope do
          target_directory ||= "."
          cfg = Pgpm::RPM::Mock::Config.new(os.mock_config, path: target_directory)
          srpm = [srpm] if srpm.is_a?(String)
          srpm.reduce(nil) do |b, rpm|
            op = Pgpm::RPM::Mock::Operation.rebuild(rpm, config: cfg.path, result_dir: target_directory)
            b.nil? ? op : b.chain(op)
          end
        end
      end
    end
  end
end
