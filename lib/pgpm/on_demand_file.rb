# frozen_string_literal: true

module Pgpm
  class OnDemandFile
    attr_reader :name

    def initialize(name, proc)
      @name = name
      @proc = proc
    end

    private

    def respond_to_missing?(symbol)
      @io ||= @proc.call
      @io.respond_to?(symbol)
    end

    def method_missing(name, *args)
      @io ||= @proc.call
      @io.send(name, *args)
    end
  end
end
