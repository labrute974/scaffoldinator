###############################################
# Build shell script part for the commands task

require 'erb'

module Builders
  class Command
    def self.get_template
      %{
    ##########################
    # COMMAND <%= @command %>

    <%= @command %>

    ##### END COMMAND <%= @command %> #####
      }
    end

    def self.build command, dry_run = false
      @command = command["exec"]

      renderer = ERB.new(self.get_template)
      renderer.result(binding)
    end
  end
end
