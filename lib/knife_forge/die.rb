


module KnifeForge
  class Die
    HASH_CHARS = 'abcdefghijklmnopqrstuvwxyz1234567890'
    attr_accessor :config

    def initialize(config)
      @config = config
    end

    def options
      @die_options ||= {
        :node_name         => node_name,
        :region            => region,
        :image             => image,
        :availability_zone => availability_zone
      }.merge @config.knife
    end

    def node_name
      unless @config.knife[:node_name].nil?
        @config.knife[:node_name]
      else
        @node_name ||= @config.forge[:base_node_name].chomp('-') + "-" + serial
      end
    end

    def region
      unless @config.knife[:region].nil?
        return @config.knife[:region].to_sym
      else
        return @region ||= Proc.new {
          choice  = random(@config.forge[:regions].size).floor
          @config.forge[:regions].keys[choice]
        }.call
      end
    end

    def availability_zone
      unless @config.knife[:availability_zone].nil?
        @config.knife[:availability_zone]
      else
        @availability_zone ||= Proc.new {
          choice  = random(@config.forge[:regions][region][:availability_zones].size).floor
          @config.forge[:regions][region][:availability_zones][choice]
        }.call
      end
    end

    def image
      unless @config.knife[:image].nil?
        return @config.knife[:image]
      else
        @config.forge[:regions][region][:image]
      end
    end

    def serial(length=5)
      str = ''
      length.times do
        str += HASH_CHARS.chars.to_a[random(HASH_CHARS.length).floor]
      end

      return str
    end

    def random(max)
      Kernel.rand(max)
    end
  end
end
