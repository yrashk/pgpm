# frozen_string_literal: true

require "dry/inflector"

module Pgpm
  class Package
    include Pgpm::Aspects::InheritanceTracker
    include AbstractPackage
    include Sources
    include Naming
    include Metadata
    include Dependencies
    include Git
    include GitHub
    include PGXN
    include Versioning
    include Subscripting
    include Enumerating
    include Building
    include Initialization
    include Packaging

    def inspect
      "#<#{self.class}:#{self.class.package_name} #{version}>"
    end

    abstract_package
  end
end
