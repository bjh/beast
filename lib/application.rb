require 'socket'
require 'mimetypes'
require 'headers'
require 'status'


class Application
  include MimeTypes
  include Headers
  include Status
  
  attr_writer :suppress_cookie_header_output
  
  def initialize(site, port, host='localhost')

    @site = site
    @host = host
    @port = port
    @method = nil
    @path = nil
    @socket = nil

    @suppress_cookie_header_output = true
  end
  
  def run    
    # catch CTRL-C
    trap('INT') {
      puts "\ntime for the beast to take a nap...\n"
      @socket.close if @socket && !@socket.closed?
      exit(69)
    }
    
    #	read from the socket the HTTP request
    #	check it’s a simple GET command
    #	check no parent directory requested to escape the web servers home directory
    #	if no file name given assume index.html
    #	check the file extension is valid and supported
    #	check the file is readable by opening it
    #	transmit the HTTP header to the browser
    #	transmit the file contents to the browser
    #	if LINUX sleep for one second to ensure the data arrives at the browser
    #	stop
    
    server = TCPServer.new(@host, @port)
    
    loop do
      @socket = server.accept
      @socket.sync
      
      #puts "SOCKET:CLASS #{@socket.class}"
      #request = @socket.gets      
      log "#{@socket.peeraddr}"
      
      begin
        headers = parse_headers(@socket)
        #body    = parse_body()
        #print_headers(headers)
        requesting = @site+@path
        
        puts "HTTP METHOD: #{@method}"
        puts "REQUEST PATH: #{requesting}"        
        
        if get?
          if File.file? requesting
            serve_file(requesting) 
          else
            @socket.print Status[404]
          end
        else
          @socket.print Status[400]
        end
      ensure
        @socket.close if not @socket.closed?
      end      
    end
  end
  
private
  
  def serve_file(path)
    ext = File.extname(path).gsub('.', '')
    
    if MimeTypes.handle? ext
      @socket.print Status[200]
      @socket.print Headers[:content_type, MimeTypes[ext]]
      @socket.print "\r\n"
      
      begin
        file = File.open(path, "rb")
      
        while !file.eof?
          @socket.write(file.read(256))
        end
        
        file.close
      rescue IOError, SocketError, SystemCallError
        puts "ERROR MOFO!"
      ensure
        file.close if !file.closed?
      end
    else
      @socket.print Status[415]
    end
  end
  
  # read from socket until a blank line is reached
  def parse_headers(socket)
    headers = {}
    
    lc = 0
    
    while (line = @socket.gets)
      line.strip!
      break if line.size == 0
      #puts "RAW #{line}"
      parse_http_method(line) if lc == 0
      
      key, value = line.split(": ")
      key = key.upcase.gsub('-', '_')
      key = "HTTP_#{key}" if !%w[CONTENT_TYPE CONTENT_LENGTH].include?(key)
      headers[key] = value
      lc += 1
    end
    headers
  end
  
  def get?
    @method.downcase == 'get'
  end
  
  def log(msg)
    $stderr.puts msg
  end

  def file?(path)
    #return nil if
  end
  
  def parse_http_method(line)
    @method, @path, *rest = line.split
  end    
  
  def print_headers(headers)
    80.times {putc '_'}
    putc "\n"
    
    if @suppress_cookie_header_output
      pp headers.merge({"HTTP_COOKIE" => 'output-suppressed'})
    else
      pp headers
    end
  end
end