class HomeController < ApplicationController
  before_filter :general_authentication
  before_filter :get_entity_manager
  after_filter :close_entity_manager
  layout 'examtracker_layout'
  
  
    
  def radiologist
  end
  
  def technologist
  end
  
  def sche_registrar
  end
  
  def transcript
  end
  
  def others
  end
  
  def search
  end

end
