require 'logger'

begin
  require 'ansi'
  ansi_included = true
rescue
  puts "need to install gem ssoroka-ansi to get colored log output"
  ansi_included = false
end

$LOGGER = Logger.new($stdout)


class ColoredOutput < Logger::Formatter
  def call(severity, time, program_name, message)
    if severity == "ERROR"
      _error(message)
    elsif severity == "INFO"
      _info(message)
    elsif severity == "WARN"
      _warn(message)
    elsif severity == "DEBUG"
      _warn(debug)
    else
      super
    end
  end
private  
  def _format(message)
    msg << colon() << message
    [border(), msg, border()].join("\n") + "\n"
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




if ansi_included
  $LOGGER.formatter = ColoredOutput.new
end