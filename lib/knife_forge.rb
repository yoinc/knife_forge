
require 'rubygems'
require 'yaml'
require 'mixlib/cli'
require 'mixlib/config'
# require 'ap'


gem 'chef'
gem 'knife-ec2'
require 'chef'
require 'chef/knife/ec2_server_create'
# require 'chef/knife/ec2_instance_data'
# require 'chef/knife/ec2_server_delete'
# require 'chef/knife/ec2_server_list'


$:.unshift File.dirname(__FILE__)


module KnifeForge
  VERSION = '1.0.0'

  autoload :Batch,   'knife_forge/batch'
  autoload :Config,  'knife_forge/config'
  autoload :Die,     'knife_forge/die'
  autoload :Hammer,  'knife_forge/hammer'
  autoload :Options, 'knife_forge/options'
  
end
