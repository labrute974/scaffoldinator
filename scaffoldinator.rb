#! /usr/bin/env ruby

require "thor"
require "yaml"

################
#
# run_cmd
# Runs shell commands

def run_cmd(cmd)
  output = `#{cmd}`
  err("#{cmd} failed to run -- #{output}") unless $?.exitstatus == 0

  output.strip
end

def err(output)
  error "Error: #{output}"
  exit 1
end

SSHKEY = "keys/setup.pem"

class Scaffoldinator < Thor
  desc "setup", "Setup the remote host with ssh keys"
  option :hosts, :aliases => "-H", :type => :string,  :desc => "comma-delimited list of hosts"
  def setup
    # Create keys directory
    Dir.mkdir "keys" unless Dir.exists? "keys"

    # Test if ssh key exists already or not
    unless File.exists? SSHKEY
      puts "* Generating SSH keypair"
      sshkeygen = run_cmd "type -p ssh-keygen"
      run_cmd "#{sshkeygen} -t rsa -f #{SSHKEY} -N '' -q"
    end

    if options[:hosts]
      options[:hosts].split(',').each do |h|
        host, port = h.split(':')
        port ||= 22

        puts "* Copy public key on host #{host}, port #{port}"
        run_cmd "cat #{SSHKEY}.pub | ssh -p #{port} #{host} \"cat >> ~/.authorized_keys\""
      end
    end
  end


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
