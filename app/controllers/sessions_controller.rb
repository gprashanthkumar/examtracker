
class SessionsController < ApplicationController
  layout 'examtracker_layout'
   before_filter :general_authentication
  before_filter :get_entity_manager
  def new
  end
  
  def get_sessions
    session.delete 'init' 
      @employee = Employee.get_employee(session[:username])
      puts "Prashanth" + @employee.to_s;
  end
  
  def create    
    render 'new'
  end

  def destroy
  end
end

