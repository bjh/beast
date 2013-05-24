require 'logger'

module Lumber
  class ColoredOutput < Logger::Formatter
    
    def call(severity, time, program_name, message)
      severity = "_#{severity.downcase}".to_sym
      
      begin
        self.send(severity, message)
      rescue
        super
      end
    end
    
  private  
    def _format(message)
      msg = colon() + message
      
      #[border(), msg, border()].join("\n") + "\n"
      "#{msg}\n"
    end

    def _error(message)
      _format("#{message}".colorize(:red))
    end

    def _info(message)
      _format("#{message}".colorize(:blue))
    end

    def _warn(message)
      _format("#{message}".colorize(:yellow))
    end

    def _debug(message)
      _format("#{message}".colorize(:cyan))
    end

    def colon
      ": ".colorize(:black)
    end

    def border(n=1)
      "-" * n
    end  
  end
end