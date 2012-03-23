

# Options Precedence: Highest precedence first
#   Command Line args
#   Template knife options
#   Template forge options
#   Defaults




module KnifeForge
  class Config
    attr_reader :cli, :knife, :forge, :merged_options

    def initialize(parent)
      @cli = CLI.new
      @cli.parse_options
      @knife = Knife.load(@cli.config[:forge_template])
      @forge = Forge.load(@cli.config[:forge_template])
      
      @merged_options = @cli.config.merge @knife
      @merged_options = @knife
    end

    class CLI
      include Mixlib::CLI

      option :forge_template,
        :long         => "--forge-template FORGE_TEMPLATE",
        :description  => "Yaml template for forge and knife options",
        :required     => true

      option :forge_quantity,
        :long         => "--forge-quantity QUANTITY",
        :description  => "number of servers you want built",
        :required     => true,
        :proc         => Proc.new {|q| q.to_i}

      class << self
        def clone_options(parent)
          parent.options.each do |key, data|
            option key.to_sym, data
          end
          self
        end
      end
    end

    class ConfigFile
      class << self
        def load_options(template, sub_section)
          opts = YAML.load_file(template)
          configure do |c|
            opts[sub_section].each do |key, data|
              c[key.to_sym] = data
            end
          end
        end
      end
    end

    class Knife < ConfigFile
      extend(Mixlib::Config)

      def self.load(template_path)
        load_options template_path, 'knife'
      end
    end

    class Forge < ConfigFile
      extend(Mixlib::Config)

      def self.load(template_path)
        load_options template_path, 'forge'
      end
    end
  end
end


# options = KnifeForge::Config.new Chef::Knife::Ec2ServerCreate.new
# ap options.merged_options
# ap options.forge
