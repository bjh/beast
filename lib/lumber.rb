require 'rubygems'
require 'logger'
require 'coloredoutput'

module Lumber
  @logger = Logger.new($stdout)
  @logger.datetime_format = "%H:%M "
  
  def self.date_time_format(format)
    @logger.datetime_format = format
  end
  
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



