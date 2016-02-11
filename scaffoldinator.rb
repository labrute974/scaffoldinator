#! /usr/bin/env ruby

require "thor"

class Scaffoldinator < Thor
  desc "planner", "Build the script that runs on the local/remote server"
  option :taskfile, :aliases => "-t", :desc => "specify a tasks file"
  option :"dry-run", :aliases => "-d", :type => :boolean, :desc => "See what the tasks is going to do"
  def planner
    puts options.inspect
  end
end

Scaffoldinator.start
