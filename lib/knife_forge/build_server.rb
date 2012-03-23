#!/usr/bin/env ruby

# knife ec2 server create (options)
#     -Z, --availability-zone ZONE     The Availability Zone
#     -A, --aws-access-key-id KEY      Your AWS Access Key ID
#     -K SECRET,                       Your AWS API Secret Access Key
#         --aws-secret-access-key
#         --user-data USER_DATA_FILE   The EC2 User Data file to provision the instance with
#         --bootstrap-version VERSION  The version of Chef to install
#     -N, --node-name NAME             The Chef node name for your new node
#         --server-url URL             Chef Server URL
#     -k, --key KEY                    API Client Key
#         --color                      Use colored output
#     -c, --config CONFIG              The configuration file to use
#         --defaults                   Accept default values for all questions
#     -d, --distro DISTRO              Bootstrap a distro using a template
#         --ebs-no-delete-on-term      Do not delete EBS volumn on instance termination
#         --ebs-size SIZE              The size of the EBS volume in GB, for EBS-backed instances
#     -e, --editor EDITOR              Set the editor to use for interactive commands
#     -E, --environment ENVIRONMENT    Set the Chef environment
#     -f, --flavor FLAVOR              The flavor of server (m1.small, m1.medium, etc)
#     -F, --format FORMAT              Which format to use for output
#     -i IDENTITY_FILE,                The SSH identity file used for authentication
#         --identity-file
#     -I, --image IMAGE                The AMI for the server
#         --no-color                   Don't use colors in the output
#     -n, --no-editor                  Do not open EDITOR, just accept the data as is
#         --no-host-key-verify         Disable host key verification
#     -u, --user USER                  API Client Username
#         --prerelease                 Install the pre-release chef gems
#         --print-after                Show the data after a destructive operation
#         --region REGION              Your AWS region
#     -r, --run-list RUN_LIST          Comma separated list of roles/recipes to apply
#     -G, --groups X,Y,Z               The security groups for this server
#     -S, --ssh-key KEY                The AWS SSH key id
#     -P, --ssh-password PASSWORD      The ssh password
#     -x, --ssh-user USERNAME          The ssh username
#     -s, --subnet SUBNET-ID           create node in this Virtual Private Cloud Subnet ID (implies VPC mode)
#         --template-file TEMPLATE     Full path to location of template to use
#     -V, --verbose                    More verbose output. Use twice for max verbosity
#     -v, --version                    Show chef version
#     -y, --yes                        Say yes to all prompts for confirmation
#     -h, --help                       Show this message


require 'rubygems'
require 'yaml'


module BuildServer




  class Master
    def initialize
      @options = Options.new ARGV
      @logger  = Logger.new @options
      @runner  = Runner.new @options, @logger
      @viewer  = Viewer.new @logger
    end

    def run
      @logger.initialize_log @runner.knife_command
      runner_pid = spawn @runner.command_with_logging
      Kernel.sleep(2)
      viewer_pid = spawn @viewer.command

      Process.detach(viewer_pid)
      Process.wait(runner_pid)
      Process.kill("HUP", viewer_pid)
    end

    def spawn(command)
      child_pid = Kernel.fork

      if child_pid.nil?
        exec command
      else
        return child_pid
      end
    end
  end

  class Viewer
    def initialize(logger)
      @logger = logger
    end

    def command
      "tail -n 100 -f #{@logger.path}"
    end
  end
end
BuildServer::Master.new.run
