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
      _format(ANSI.color(:red, :bold => true) { "#{message}" })
    end

    def _info(message)
      _format(ANSI.color(:blue, :bold => true) { "#{message}" })
    end

    def _warn(message)
      _format(ANSI.color(:yellow, :bold => true) { "#{message}" })
    end

    def _debug(message)
      _format(ANSI.color(:cyan, :bold => true) { "#{message}" })
    end

    def colon
      ANSI.color(:black, :bold => true) {": "}
    end

    def border(n=1)
      "-" * n
    end  
  end
end