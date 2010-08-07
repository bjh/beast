

module Headers
  # load and eval this monster, way to huge to have listed here
  path = File.dirname(__FILE__)
  @headers = eval(File.open("#{path}/headers_include.rb").read)
  
  def self.[](key, value)
    if @headers[key.to_sym]
      %{#{@headers[key.to_sym]}: #{value}\r\n}
    else
      puts "ERROR: no header for type: #{key}"
      ''
    end
  end
end