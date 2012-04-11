

# Options Precedence: Highest precedence first
#   Command Line args
#   Template knife options
#   Template forge options
#   Defaults




module KnifeForge
  class Config
    attr_reader :cli, :knife, :forge

    def initialize(parents)
      @cli = cli_args(parents)

      knife_defaults = Options.new.load_defaults(@cli[:forge_template], 'knife')
      forge_defaults = Options.new.load_defaults(@cli[:forge_template], 'forge')

      @knife = knife_defaults.merge @cli
      # Mixlib is a piece of shit.
      @knife.delete(:forge_template)
      @knife.delete(:forge_quantity)

      @forge = forge_defaults
    end
    
    def cli_args(parents)
      parents.each do |parent|
        CLI.clone_options(parent)
      end
      knife_cli = CLI.new
      knife_cli.parse_options(ARGV)
      knife_cli.config
    end
    
    class CLI
      include Mixlib::CLI

      option :forge_template,
        :long         => "--forge-template FORGE_TEMPLATE",
        :description  => "Yaml template for forge and knife options",
        :required     => true

      option :forge_quantity,
        :long        => "--forge-quantity QUANTITY",
        :description => "number of servers you want built",
        :default     => 1,
        :proc        => Proc.new {|q| q.to_i}

      class << self
        def clone_options(parent)
          parent.options.each do |key, data|
            key = data[:long].split(' ')[0]
            key = key.slice(2, key.length).gsub('-','_')
            opts = (data[:short].nil? ? {} : {:short => data[:short]} )
            option key.to_sym, opts.merge({
              :long        => data[:long],
              :description => data[:description]
              })
          end
          self
        end
      end
    end

    class Options < Hash

      def load_defaults(template, sub_section)
        opts = YAML.load_file(template)
        opts[sub_section].each do |key, value|
          self[key.to_sym] = value.is_a?(Hash) ? Options.symbolize_keys(value) : value
        end
        self
      end

      def override(overrides)
        self.each_key do |key|
          self[key] = overrides[key] unless overrides[key].nil?
        end
      end

      def self.symbolize_keys(hash)
        hash.inject({}) do |result, (key, value)|
          new_key         = key.is_a?(String) ? key.to_sym : key
          new_value       = value.is_a?(Hash) ? symbolize_keys(value) : value
          result[new_key] = new_value
          result
        end
      end
    end
  end
end

