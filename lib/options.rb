require 'optparse' 

class Options
  
  attr_reader :options
  
  def initialize
    @options = {}
    @parser
    prepare
  end
  
  def run  
    begin
      @parser.parse!
    rescue
      # show help/usage
      puts @parser
      exit
    end
  end
  
  def [](key)
    @options[key]
  end
  
private

  def prepare
    @parser = OptionParser.new do|opts|
     # Set a banner, displayed at the top of the help screen.
     opts.banner = "Usage: beast [options] ..."

     # Define the options, and what they do
      @options[:directory] = File.expand_path(File.dirname(__FILE__))
      opts.on( '-d DIRECTORY', '--directory', 'directory for the beast to chew on' ) do |path|
        path.strip!
    
        @options[:directory] = path
    
        if path == '.' || path == ""
          @options[:directory] = File.expand_path(File.dirname(__FILE__))
        end
      end

      @options[:port] = 6969
      opts.on( '-p PORT', '--port', 'port number for the beast to bite on to. default is 6969' ) do |port|
        @options[:port] = port
      end
     # show help
     opts.on( '-h', '--help', 'Display this screen' ) do
       puts opts
       exit
     end
    end
  end
end