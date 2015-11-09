
class SessionsController < ApplicationController
  layout 'examtracker_layout'
  def new
  end
  
  def get_sessions
    #session[:user_id]=121
    #session[:user_name] = "Ashish Kumar"
    #sessions_json = [{:session_user_id=>session[:user_id], :session_user_name=>session[:user_name]}].to_json
    #puts sessions_json
    
    @x = session.to_list()
  end
  
  def create
    render 'new'
  end

  def destroy
  end
end

