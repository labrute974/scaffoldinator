###############################################
# Build ERB file to be copied on server, and copy

require 'erb'

module Builders
  class File
    def self.build file, dry_run = false
      puts file
    end
  end
end
