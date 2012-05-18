

module KnifeForge
  class Hammer
    def initialize(die)
      @die = die
    end

    def drop
      return "#{@die.config.forge[:preprocessor]} knife ec2 server create #{cli_args}"
    end

    def cli_args
      @die.options.map do |key, value|
        unless value.nil?
          "--#{key.to_s.gsub('_','-')} #{value}"
        else
          ""
        end
      end.join(' ')
    end
  end
end
