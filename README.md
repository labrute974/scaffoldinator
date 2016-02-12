# Scaffoldinator

Scaffoldinator is just a play place to build a somewhat Ansible / puppet like config management tool.

Note that I have no intention of actually building something Prod-ready. This is just a playground.

Also, this could become a thing, or not! Note that this is very simplistic
view of what a config management could look like.

## Requirements

To use it, you need to have ruby installed, together and bundler:

    gem install bundler
    # from git repo root
    bundle install

You will also need **openssh-client**.

## Usage

To know how to use the scaffoldinator command line, run:

    bundle exec ./scaffoldinator help

All the *--hosts* options for subcommands can take username and port.

Example:

    bundle exec ./scaffoldinator setup -H root@127.0.0.1:2222,root@192.168.0.1

By default, the port is 22.

### Configuration task file

The task file is just a *yaml* file. Check [here](http://www.yaml.org/spec/1.2/spec.html) for yaml.

Each element of the root array in the file is a task.
Tasks are run in the order specified in the taskfile.

Example of a task file:

    - desc: Just a description of the task
      <resource>:
        <resource parameters>

*desc* is just a description that will be printed out when the task will be run.

Resources are the resource that you can create to configure your server.

#### files

    files:
      - name: just a name used in the output
        source: location of the file locally
        dest: destination of the file on remote
        vars:
          - key: value
          - key: value
          ...

This resource creates a file on the destination host.

The source file can be a plain ready text file, or it can be an
[ERB](http://codingbee.net/tutorials/ruby/ruby-the-erb-templating-system/) template.

#### services

    services:
      - name: service_name
        running: true or false

This manages services on the remote host.

Values acceptable for running are **true** of **false** only.

#### packages

    packages:
      - name: pkg_name

This install a package on

### Notify service to reload

To notify a service to reload, it's pretty simple.

In your *yaml* scaffold, add a key value: *service: <service_name>*

Example:

    - desc: Configure apache with mod_php and helloworld config
      files:
        - name: helloworld_app
          source: files/10-hwapp_apache.conf
          dest: /etc/apache2/sites-available/10-hwapp.conf
          service: apache2
    - desc: Ensure apache service is up
      service:
        - name: apache2
          running: true

One of the file in the first task has a **service: apache2**.

This will trigger the restart of the service apache2.

Here the order is very important. This works only because the file is defined in
a task that runs before the task that contains the service.

## Notes

The application code is right now leaving in the config management code.

Obviously, this is not optimal, but for the sake of the testing / example,
that's where it lives (in code/).

## TODO

 * At this stage, **builders** only support Ubuntu.
 * Manage package version
 * Needs to run as root on remote host at the moment
 * Manage package upgrades / downgrades
 * Add more syntax checks / tests of parameters
 * Use of net-ssh library to have remote command streaming output
 * Lots more? ...
