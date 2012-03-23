

module KnifeForge
  class Batch
    def run
      @config = Config.new Chef::Knife::Ec2ServerCreate.new

      @config.cli.config[:forge_quantity].times do
        logger = Logger.new(@config)
        spawn logger.wrap_command(Hammer.new(Die.new @config).drop)
      end
    end

    def spawn(cmd)
      child_pid = Kernel.fork
    
      if child_pid.nil?
        exec cmd
      else
        Process.detach(child_pid)
        return child_pid
      end
    end
  end

  class Logger
    def initialize(options)
      @options = options
      initialize_log
    end

    def path
      @path ||= "log/forge/#{@options.knife[:node_name]}.log"
    end

    def initialize_log
      `mkdir -p #{File.dirname(self.path)}`
      `touch #{path}`
    end

    def wrap_command(cmd)
      "#{cmd} 2>&1 > #{path}"
    end
  end
end
