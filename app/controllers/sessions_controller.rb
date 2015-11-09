
class SessionsController < ApplicationController
  layout 'examtracker_layout'
  def new
  end
  
  def get_sessions
    session.delete 'init' 
    
  end
  
  def create    
    render 'new'
  end

  def destroy
  end
end

