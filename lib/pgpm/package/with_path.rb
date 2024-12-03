# frozen_string_literal: true

require "minitar"
require "find"
require "zlib"

module Pgpm
  class Package
    module WithPath
      def with_path(path)
        @with_path = File.absolute_path(path)
        self
      end

      def source_url_directory_name
        if @with_path
          File.basename(@with_path)
        else
          super
        end
      end

      def source
        if @with_path
          Pathname(@with_path)
        else
          super
        end
      end

      def sources
        if @with_path
          [source_tar_gz]
        else
          super
        end
      end

      private

      def source_tar_gz
        Pgpm::OnDemandFile.new("sources.tar.gz", lambda {
          s = String.new
          begin
            dir = source
            sgz = Zlib::GzipWriter.new(StringIO.new(s))
            tar = Minitar::Output.open(sgz)
            Find.find(dir) do |entry|
              stat = File.stat(entry)
              data = File.directory?(entry) ? nil : File.binread(entry)
              info = { name: Pathname(entry).relative_path_from(File.dirname(source)).to_s,
                       mode: stat.mode, uid: stat.uid, gid: stat.gid, mtime: stat.mtime }
              Minitar.pack_as_file(info, data, tar)
            end
          ensure
            # Closes both tar and sgz.
            tar.close
          end
          StringIO.open(s)
        })
      end
    end
  end
end
