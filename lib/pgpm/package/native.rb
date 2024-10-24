# frozen_string_literal: true

module Pgpm
  class Package
    module Native
      def native?(path = ".")
        Dir.glob("**/*.{c,rs,cpp,cc,zig,go,adb,s}", base: File.join(source, path)).any?
      end
    end
  end
end
