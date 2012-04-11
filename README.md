# Knife Forge :: Where knives are made

## DESCRIPTION:

Provides a template system for building servers with knife.  It also provides
batch building functionality to spin up servers in parallel and stripe them 
randomly across availability zones and regions.

## FEATURES/PROBLEMS:

- Read knife options from a template
- Command line overrides of template options (buggy)
- Build multiple nodes in parallel
- Logs build to a file named after the node
- Generates a serial file

## SYNOPSIS:

    $ forge
    Usage: /Library/Ruby/Gems/1.8/bin/forge (options)
        -Z, --availability-zone ZONE     The Availability Zone
        -A, --aws-access-key-id KEY      Your AWS Access Key ID
        -K SECRET                        Your AWS API Secret Access Key
            --aws-secret-access-key
        -u, --user-data USER_DATA_FILE   The EC2 User Data file to provision the instance with
            --bootstrap-version VERSION  The version of Chef to install
        -N, --node-name NAME             The Chef node name for your new node
        -d, --distro DISTRO              Bootstrap a distro using a template
            --ebs-no-delete-on-term      Do not delete EBS volumn on instance termination
            --ebs-size SIZE              The size of the EBS volume in GB, for EBS-backed instances
        -f, --flavor FLAVOR              The flavor of server (m1.small, m1.medium, etc)
            --forge-quantity QUANTITY    number of servers you want built
            --forge-template FORGE_TEMPLATE
                                         Yaml template for forge and knife options (required)
        -i IDENTITY_FILE                 The SSH identity file used for authentication
            --identity-file
        -I, --image IMAGE                The AMI for the server
            --no-host-key-verify         Disable host key verification
            --prerelease                 Install the pre-release chef gems
            --region REGION              Your AWS region
        -r, --run-list RUN_LIST          Comma separated list of roles/recipes to apply
        -G, --groups X,Y,Z               The security groups for this server
        -S, --ssh-key KEY                The AWS SSH key id
        -P, --ssh-password PASSWORD      The ssh password
        -x, --ssh-user USERNAME          The ssh username
        -s, --subnet SUBNET-ID           create node in this Virtual Private Cloud Subnet ID (implies VPC mode)
        -T Tag=Value[,Tag=Value...]      The tags for this server
            --tags
            --template-file TEMPLATE     Full path to location of template to use

Example: Building four servers from the template:

    $ forge --forge-template path/to/template.yml --forge-quantity 4


Example Configuration file:  base.yml

    knife:
      flavor: 'm1.small'
      groups: 'lockdown'
      ssh_user: 'ubuntu'
      ssh_key: 'your_key_pair_name'
      identity_file: 'path/to/your/key/pair/pemfile.pem'
      run_list: '"role[base]"'
      tags: "Chef=true"

    forge:
      preprocessor: 'ec2_hostname'
      base_node_name: 'base'
      regions: 
        us-east-1:
          image: 'ami-4dad7424'
          availability_zones:
            - 'us-east-1a'
            - 'us-east-1b'
            - 'us-east-1c'
            - 'us-east-1d'
        us-west-1:
          image: 'ami-11c59d54'
          availability_zones:
            - 'us-west-1a'
            - 'us-west-1b'
        us-west-2:
          image: 'ami-a8ec6098'
          availability_zones:
            - 'us-west-2a'
            - 'us-west-2b'


## REQUIREMENTS:

Ruby 1.8.7 or greater

## INSTALL:

    gem install knife_forge

## DEVELOPERS:

Fork me on Github and send me a pull request.  FYI, here's my todo list:

- fix command line override bugs.
- replace the restrictive base node name with serial appended to a custom 
  formatable string that has access to any of the knife command line options.
- command line switch to run in the foreground
- remove the ec2 specific items to allow it to work with any hosting provider


## LICENSE:

(The MIT License)

Copyright (c) 2012 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
