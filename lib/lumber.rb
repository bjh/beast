require 'rubygems'
require 'logger'
require 'coloredoutput'

begin
  require 'ansi'
  $ansi_included = true
rescue
  puts "need to install gem ssoroka-ansi to get colored log output"
    $ansi_included = false
end

module Lumber
  @logger = Logger.new($stdout)
  
  if $ansi_included
    @logger.formatter = Lumber::ColoredOutput.new
  end

  def self.error(message)
    @logger.error(message)
  end
  
  def self.info(message)
    @logger.info(message)
  end
  
  def self.warn(message)
    @logger.warn(message)
  end
  
  def self.debug(message)
    @logger.debug(message)
  end
end



