
class SessionsController < ApplicationController
  layout 'examtracker_layout'
  def new
  end
  
  def get_sessions
    session.delete 'init' 
      @employee = Employee.get_employee
      puts @employee.to_list();
  end
  
  def create    
    render 'new'
  end

  def destroy
  end
end

