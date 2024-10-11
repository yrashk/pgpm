# frozen_string_literal: true

module Pgpm
  module RPM
    module Mock
      class Config
        def initialize(name)
          @source = name
          @path = File.absolute_path(File.join(File.dirname(__FILE__),"..","mock", "configs","#{name}.cfg"))
        end

        attr_reader :path

      end
    end
  end
end
