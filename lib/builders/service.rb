###############################################
# Build shell script part for the services task

require 'erb'


module Builders
  class Service
    def self.get_template()
      %{
    ##########################
    # SERVICE <%= @service %>

    service="<%= @service %>"
    action="<%= @action %>"
    dryrun="<%= @dry_run %>"

    ## Ensure service is in the right mode
    function run_action {
      service $service status &> /dev/null
      state=$?

      case $os in
        *Ubuntu*)
          case $action in
            "stop")
              [ $state -eq 0 ] && cmd="service $service stop"
              ;;
            "start")
              [ $state -ne 0 ] && cmd="service $service start"
              ;;
            "reload")
              [ $state -ne 0 ] && cmd="service $service start" || cmd="service $service reload"
              ;;
          esac
          ;;
      esac

      [[ "$dryrun" == "true" ]] && echo "dry run: ${cmd}" || $cmd
    }

    echo " - Ensure ${service} is in mode: ${action}"
    run_action $action

    ##### END SERVICE <%= @service %> #####
      }
    end

    def self.build service, reload = false, dry_run = false
      @service  = service["name"]
      @dry_run  = dry_run
      @action   = "stop"

      @action = if reload
         "reload"
      else
        "start"
      end if service["running"]

      renderer = ERB.new(self.get_template)
      renderer.result(binding)
    end
  end
end
