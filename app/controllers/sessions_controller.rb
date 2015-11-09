
class SessionsController < ApplicationController
  layout 'examtracker_layout'
  def new
  end
  
  def get_sessions
  
  end
  
  def create
  session.delete 'init'
    do_stuff
    
    render 'new'
  end

  def destroy
  end
end

