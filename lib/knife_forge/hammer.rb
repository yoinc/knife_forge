

module KnifeForge
  class Hammer
    def initialize(die)
      @die = die
    end

    def drop
      args = "ec2 server create".split + ARGV
      return "knife ec2 server create #{cli_args}"
    end

    def cli_args
      @die.options.map do |key, value|
        "--#{key.to_s.gsub('_','-')} #{value}"
      end.join(' ')
    end
  end
end
