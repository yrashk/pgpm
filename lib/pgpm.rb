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
  pkg_loader = Zeitwerk::Registry.loaders.find { |l| l.dirs.include?(path.to_s) }
  return pkg_loader if pkg_loader

  pkg_loader = Zeitwerk::Loader.new
  pkg_loader.push_dir(path)
  pkg_loader.enable_reloading
  pkg_loader.setup
  pkg_loader.eager_load
  pkg_loader
end

module Pgpm
end
