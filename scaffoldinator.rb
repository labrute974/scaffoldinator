#! /usr/bin/env ruby

require "thor"
require "yaml"

def err(output)
  error "Error: #{output}"
  exit 1
end

class Scaffoldinator < Thor
  desc "planner", "Build the script that runs on the local/remote server"
  option :taskfile, :aliases => "-t", :type => :string, :desc => "specify a tasks file"
  option :"dry-run", :aliases => "-d", :type => :boolean, :desc => "See what the tasks is going to do"
  option :verbose, :aliases => "-v", :type => :boolean, :desc => "Verbose mode."
  def planner
    # Test if task file passed exists
    err("File #{options[:taskfile]} does not exist.") unless File.exists? options[:taskfile]

    yaml = YAML.load_file options[:taskfile]

    puts yaml.inspect
  end
end

Scaffoldinator.start
