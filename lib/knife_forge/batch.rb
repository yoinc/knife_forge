

module KnifeForge
  class Batch
    def run
      parents = [Chef::Knife::Ec2ServerCreate.new]
      parents << Chef::Application::Knife.new
      @config = Config.new parents

      @config.cli[:forge_quantity].times do
        die = Die.new @config
        logger = Logger.new(die.options)
        spawn logger.wrap_command(Hammer.new(die).drop)
      end
    end

    def spawn(cmd)
      child_pid = Kernel.fork
    
      if child_pid.nil?
        puts "Spawning #{cmd}"
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
      @path ||= "log/forge/#{@options[:node_name]}.log"
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
