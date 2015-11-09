
class SessionsController < ApplicationController
  layout 'examtracker_layout'
  def new
  end
  
  def get_sessions
    session.delete 'init'
    do_stuff
  end
  
  def create    
    render 'new'
  end

  def destroy
  end
end

