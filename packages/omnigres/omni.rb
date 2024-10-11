# frozen_string_literal: true

require "minitar"
require "find"
require "zlib"
require "progress"

module Omnigres
  class Omni < Pgpm::Package
    github "omnigres/omnigres", download_version_tags: false

    def initialize(version)
      @fetch_previous_version = true
      super
    end

    def summary
      "Advanced adapter for Postgres extensions"
    end

    def description
      summary
    end

    def self.package_versions
      ExtensionDiscovery.new.extension_versions["omni"]
    end

    def version_git_commit
      ExtensionDiscovery.new.extension_git_revisions["omni"][version]
    end

    def configure_steps
      ["export PIP_CONFIG_FILE=$(pwd)/deps/pip.conf",
       "cmake -S extensions/omni -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo " \
         "-DOPENSSL_CONFIGURED=1 -DPG_CONFIG=$PG_CONFIG -DCPM_SOURCE_CACHE=$(pwd)/deps/_deps"]
    end

    def build_steps
      [
        "cmake --build build --parallel --target package_omni_extension",
        "cmake --build build --parallel --target package_omni_migrations",
        "scripts/generate_upgrade.sh #{name} #{previous_version.version} " \
          "$(pwd)/omnigres-#{previous_version.version_git_commit} #{version} $(pwd)"
      ]
    end

    def install_steps
      [
        "mkdir -p $PGPM_BUILDROOT/$($PG_CONFIG --sharedir)/extension",
        "mkdir -p $PGPM_BUILDROOT/$($PG_CONFIG --pkglibdir)",
        "cp build/packaged/*.so $PGPM_BUILDROOT/$($PG_CONFIG --pkglibdir)",
        "cp build/packaged/extension/*.control $PGPM_BUILDROOT/$($PG_CONFIG --sharedir)/extension",
        "cp build/packaged/extension/*.sql $PGPM_BUILDROOT/$($PG_CONFIG --sharedir)/extension"
      ]
    end

    def license
      "Apache 2.0"
    end

    def build_dependencies
      %w[cmake openssl-devel python3 python3-devel nc sudo] + super
    end

    def dependencies
      ["openssl"] + super
    end

    def source_url_directory_name
      "omnigres-#{version_git_commit}"
    end

    class UnsupportedVersion < StandardError
      def message
        "This version of omnigres extension is too old"
      end
    end

    def deps_tar_gz(dir_name = "deps")
      @os = Pgpm::OS.auto_detect
      if @os.is_a?(Pgpm::OS::RedHat)
        system "sudo dnf -y install libxml2-devel libxslt-devel cmake gcc g++ python3-devel"
      end
      recipe_hash = Digest::SHA1.hexdigest(File.read(__FILE__) + scripts_tar_gz.read)
      deps = File.join(source, dir_name)
      src = source.to_s
      ready_marker = File.join(src, ".complete.#{recipe_hash}")
      targz = File.join(src, "deps-#{recipe_hash}.tar.gz")
      unless File.exist?(ready_marker)
        raise UnsupportedVersion unless File.directory?(File.join(src, "cmake", "dependencies"))
        # FIXME: this is not perfect as we're still required to have the build-time dependencies
        # required for this (such as g++, python3-devel, cmake, g++, etc...)
        unless system "cmake -S #{src}/cmake/dependencies -B #{deps} -DCPM_SOURCE_CACHE=#{deps}/_deps"
          raise "Can't fetch dependencies"
        end

        begin
          sgz = Zlib::GzipWriter.new(File.open(targz, "wb"))
          tar = Minitar::Output.open(sgz)
          files = Find.find(deps).filter do |entry|
            # Don't include .git
            Pathname(entry).each_filename.map { |f| f == ".git" }.none?
          end
          files.with_progress("Preparing #{dir_name}.tar.gz") do |entry|
            stat = File.stat(entry)
            data = File.directory?(entry) ? nil : File.binread(entry)
            info = { name: Pathname(entry).relative_path_from(src).to_s,
                     mode: stat.mode, uid: stat.uid, gid: stat.gid, mtime: stat.mtime }
            Minitar.pack_as_file(info, data, tar)
          end
        ensure
          tar.close
        end
        FileUtils.touch(ready_marker)
      end
      Pgpm::OnDemandFile.new("#{dir_name}.tar.gz", -> { File.open(targz) })
    end

    attr_accessor :fetch_previous_version

    def sources
      srcs = super
      srcs.push(deps_tar_gz)
      if fetch_previous_version && previous_version
        begin
          prev_version = previous_version
          puts "Fetching previous version #{prev_version.version} to be able to generate migrations"
          prev_version.fetch_previous_version = false
          srcs.push(prev_version.sources[0]) # archive
          srcs.push(prev_version.deps_tar_gz("deps-prev")) # deps
        rescue UnsupportedVersion
          # ignore this one, just don't build an upgrade
          puts "Ignore #{prev_version.version}, it is unsupported"
        end
      end

      srcs.push(scripts_tar_gz)
      srcs
    end

    private

    def previous_version
      return @previous_version if @previous_version

      sorted_versions = self.class.package_versions.sort_by { |v| SemverDialects.parse_version("cargo", v) }.map(&:to_s)
      index = sorted_versions.index(version)
      return unless index.positive?

      @previous_version = self.class[sorted_versions[index - 1]]
    end

    def scripts_tar_gz
      s = String.new
      begin
        dir = File.join(File.dirname(__FILE__), "scripts")
        sgz = Zlib::GzipWriter.new(StringIO.new(s))
        tar = Minitar::Output.open(sgz)
        Find.find(dir) do |entry|
          stat = File.stat(entry)
          data = File.directory?(entry) ? nil : File.binread(entry)
          info = { name: Pathname(entry).relative_path_from(File.dirname(__FILE__)).to_s,
                   mode: stat.mode, uid: stat.uid, gid: stat.gid, mtime: stat.mtime }
          Minitar.pack_as_file(info, data, tar)
        end
      ensure
        # Closes both tar and sgz.
        tar.close
      end
      Pgpm::OnDemandFile.new("scripts.tar.gz", -> { StringIO.open(s) })
    end
  end
end
