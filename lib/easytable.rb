$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

require 'easytable/types'
require 'easytable/table'

module EasyTable

  VERSION = '0.0.1'

  def self.version
    VERSION
  end

end
