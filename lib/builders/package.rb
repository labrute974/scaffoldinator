###############################################
# Build shell script part for the packages task

require 'erb'

def get_template()
  %{
##########################
# PACKAGE <%= @pkg_name %>

pkg="<%= @pkg_name %>"
dryrun="<%= @dry_run %>"
os=$(sed '1!d' /etc/issue)

## Check if package installed
function check {
  case $os in
    *Ubuntu*)
      cmd="dpkg -l $pkg"
      ;;
  esac

  $cmd > /dev/null >&2
  return $?
}

## Install the package
function install {
  case $os in
    *Ubuntu*)
      cmd="apt-get -y install $pkg"
      ;;
  esac

  [[ "$dryrun" == "true" ]] && echo "dry run: ${cmd}" || $cmd
}

check && echo " - Package $pkg is already installed." || install

##### END PACKAGE <%= @pkg_name %> #####
  }
end


module Builders
  class Package
    def self.build pkg, dry_run = false
      @pkg_name = pkg["name"]
      @dry_run  = dry_run

      renderer = ERB.new(get_template)
      renderer.result(binding)
    end
  end
end
