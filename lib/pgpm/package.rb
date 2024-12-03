# frozen_string_literal: true

require "dry/inflector"

module Pgpm
  class Package
    include Pgpm::Aspects::InheritanceTracker
    include AbstractPackage
    include Source
    include Naming
    include Metadata
    include Dependencies
    include Git
    include GitHub
    include PGXN
    include Versioning
    include Subscripting
    include Enumerating
    include Native
    include Building
    include Make
    include Rust
    include Initialization
    include Packaging
    include Contrib
    include WithPath

    def inspect
      "#<#{self.class}:#{self.class.package_name} #{version}>"
    end

    abstract_package
  end
end
