# frozen_string_literal: true

require "zeitwerk"
require "pathname"

class CustomInflector < Zeitwerk::GemInflector
  def camelize(basename, _abspath)
    # Specify your custom logic here
    # This tells Zeitwerk that 'rpm' should be 'RPM' and 'os' should be 'OS'
    case basename
    when "rpm"
      "RPM"
    when "os"
      "OS"
    when "pgxn"
      "PGXN"
    else
      super
    end
  end
end

loader = Zeitwerk::Loader.for_gem
loader.inflector = CustomInflector.new(__FILE__)
loader.enable_reloading
loader.setup

define_method(:reload!) do
  loader.reload
  loader.eager_load
end

define_method(:load_packages) do |path = nil|
  path ||= Pathname(File.dirname(__FILE__)).join("..", "packages")
  loader.push_dir(path)
  reload!
end

module Pgpm
end
