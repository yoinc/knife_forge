


module KnifeForge
  class Die
    HASH_CHARS = 'ABCDEFGHIJKLMNOPQRATUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'

    def initialize(config)
      @config = config
      @die_options = {}
    end

    def options
      @options ||= cut_die
    end

    private

    def cut_die
      @config.forge.each do |key, value|
        self.send key.to_sym, value
      end

      # @config.merged_options.merge! @die_options
      opts = @config.merged_options.merge! @die_options
      @symbols = {}
      opts.each do |key, value|
        @symbols[key.to_sym] = value
      end
      @symbols
    end

    def random(max)
      rand(max)
    end

    def regions(value)
      index                 = self.random(value.length).floor
      @die_options[:region] = value[index]['name']
      @die_options[:image]  = value[index]['image']

      av_zone_index                    = self.random(value[index]['availability_zones'].length).floor

      @die_options[:availability_zone] = value[index]['availability_zones'][av_zone_index]
    end

    def base_node_name(value)
      @die_options[:node_name] = value.chomp('-') + "-" + serial
    end

    def serial(length=5)
      str = ''
      length.times do
        str += HASH_CHARS[self.random(HASH_CHARS.length).floor]
      end

      return str
    end
  end
end
