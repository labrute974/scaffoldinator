###############################################
# Build ERB file to be copied on server, and copy

require 'erb'

FileIO = File

module Builders
  class File
    def self.build file, vars = {}, dry_run = false
      raise "File #{file["source"]} not found" unless FileIO.exists? file["source"]

      @vars = file["vars"] || {}
      file["content"] = ERB.new(FileIO.read(file["source"])).result(binding)
      return file
    end
  end
end
