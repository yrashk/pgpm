# frozen_string_literal: true

module Pgpm
  module RPM
    module Mock
      class Config
        def initialize(source, path: nil)
          @source = source
          @path = path
          @digest = Digest::SHA1.hexdigest(source)
        end

        def path
          f = Pathname(@path).join("mock-#{@digest}.cfg")
          File.write(f, @source) if !File.exist?(f) || @digest != Digest::SHA1.hexdigest(File.read(f))
          f
        end
      end
    end
  end
end
