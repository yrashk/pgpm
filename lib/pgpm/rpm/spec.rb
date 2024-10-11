# frozen_string_literal: true

require "digest"
require "open-uri"

module Pgpm
  module RPM
    class Spec
      attr_reader :package, :release, :postgres_version, :postgres_distribution

      def initialize(package, postgres_version: nil, postgres_distribution: nil)
        @package = package
        @release = 1

        @postgres_version = postgres_version || "17"
        @postgres_distribution = postgres_distribution || "postgresql#{@postgres_version}"
      end

      def versionless
        <<~EOF
          Name: pgpm-#{@package.name}-#{@postgres_version}
          Version: #{@package.version}
          Release: #{@release}%{?dist}
          Summary: #{@package.summary}
          License: #{@package.license}

          BuildRequires: #{@postgres_distribution} #{@postgres_distribution}-devel #{@postgres_distribution}-server
          Requires: pgpm-#{@package.name}-#{@postgres_version}_#{@package.version}
          BuildArch:  noarch

          %description
          #{@package.description}

          %build

          %install
          export PG_CONFIG=$(rpm -ql #{@postgres_distribution} | grep 'pg_config$')
          mkdir -p %{buildroot}$($PG_CONFIG --sharedir)/extension
          export CONTROL=%{buildroot}$($PG_CONFIG --sharedir)/extension/#{@package.extension_name}.control
          echo "default_version = '#{@package.version}'" > $CONTROL
          echo ${CONTROL#"%{buildroot}"} > filelist.txt

          %files -f filelist.txt
        EOF
      end

      def sources
        sources = @package.sources.clone
        prepare_artifacts = -> { File.open(File.join(File.dirname(__FILE__), "scripts", "prepare_artifacts.sh")) }
        sources.push(Pgpm::OnDemandFile.new("prepare_artifacts.sh", prepare_artifacts))
        sources
      end

      def to_s
        setup_opts = ["-q"]
        if @package.source_url_directory_name
          setup_opts.push("-n", @package.source_url_directory_name)
        else
          setup_opts.push("-n", "#{@package.name}-#{@package.version}")
        end

        <<~EOF
          Name: pgpm-#{@package.name}-#{@postgres_version}_#{@package.version}
          Version: 1
          Release: 1%{?dist}
          Summary: #{@package.summary}
          License: #{@package.license}
          #{sources.each_with_index.map { |src, index| "Source#{index}: #{src.name}" }.join("\n")}

          BuildRequires: #{@postgres_distribution} #{@postgres_distribution}-devel #{@postgres_distribution}-server
          #{@package.build_dependencies.map { |dep| "BuildRequires: #{dep}" }.join("\n")}
          Requires: #{@postgres_distribution}

          %description
          #{@package.description}

          %prep
          %setup #{setup_opts.join(" ")}
          #{(sources[1..] || []).filter { |s| unpack?(s) }.each_with_index.map { |_src, index| "%setup -T -D #{setup_opts.join(" ")} -a #{index + 1}" }.join("\n")}

          export PG_CONFIG=$(rpm -ql #{@postgres_distribution} | grep 'pg_config$')
          #{@package.configure_steps.map(&:to_s).join("\n")}

          %build
          export PG_CONFIG=$(rpm -ql #{@postgres_distribution} | grep 'pg_config$')
          export PGPM_BUILDROOT=%{buildroot}
          #{@package.build_steps.map(&:to_s).join("\n")}

          %install
          export PG_CONFIG=$(rpm -ql #{@postgres_distribution} | grep 'pg_config$')
          export PGPM_BUILDROOT=%{buildroot}
          find %{buildroot} -type f | sort - | sed 's|^%{buildroot}||' > .pgpm_before | sort
          #{@package.install_steps.map(&:to_s).join("\n")}
          export PGPM_EXTENSION_NAME="#{@package.extension_name}"
          export PGPM_EXTENSION_VERSION="#{@package.version}"
          cp %{SOURCE#{sources.length - 1}} ./prepare_artifacts.sh
          chmod +x ./prepare_artifacts.sh
          ./prepare_artifacts.sh
          find %{buildroot} -type f | sort - | sed 's|^%{buildroot}||' > .pgpm_after | sort
          comm -13 .pgpm_before .pgpm_after | sort -u > filelist.txt

          %files -f filelist.txt


          %changelog
        EOF
      end

      private

      def unpack?(src)
        src = src.name if src.respond_to?(:name)
        src.to_s.end_with?(".tar.gz")
      end
    end
  end
end
