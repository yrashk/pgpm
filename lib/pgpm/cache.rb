# frozen_string_literal: true

require "xdg"

module Pgpm
  class Cache
    def self.directory
      XDG.new.cache_home.join("postgres.pm")
    end
  end
end
