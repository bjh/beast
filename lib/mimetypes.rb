

module MimeTypes
  @types = {
    :gif => 'image/gif',
    :jpg => 'image/jpeg',
    :jpeg => 'image/jpeg',
    :png => 'image/png',
    :zip => 'image/zip',
    :gz => 'image/gz',
    :tar => 'image/tar',
    :htm => 'text/html',
    :html => 'text/html'
  }
  
  def self.handle?(extension)
    !@types[extension.to_sym].nil?
  end
  
  def self.[](extension)
    @types[extension.to_sym]
  end
end