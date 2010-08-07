#require 'rspec'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib' ))

require 'lumber'

describe Logger do
  before do
  end
  
  it "should have colored output" do
    Lumber::info "info"
    Lumber::warn "warning"
    Lumber::debug "debug"
    Lumber::error "error"
  end
end

