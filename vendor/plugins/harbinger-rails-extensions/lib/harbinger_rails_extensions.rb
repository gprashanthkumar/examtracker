require 'java'
require File.join(File.dirname(__FILE__), 'harbinger_tables')
require File.join(File.dirname(__FILE__), 'harbinger_tabs')
require File.join(File.dirname(__FILE__), 'harbinger_report_formating')
require File.join(File.dirname(__FILE__), 'harbinger_javascript')
require File.join(File.dirname(__FILE__), 'harbinger_sso_login')

=begin rdoc
  = Harbinger Extensions
  The harbinger extensions library is a collection of common helpers and layouts/stylesheets used when creating a harbinger application in rails.

=end

module HarbingerRailsExtensions

  module ControllerMethods
  end

  module Helpers

    def nl2br(text)
      text.gsub("\n","<br />")
    end

  end

end
