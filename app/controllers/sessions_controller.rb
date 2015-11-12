
class SessionsController < ApplicationController
  layout 'examtracker_layout'
  before_filter :general_authentication
  before_filter :get_entity_manager
  def new
  end
  
  def get_sessions
    session.delete 'init' 
      @employee = Employee.get_employee(session[:username])   
      @exams = Rad_Exam.get_rad_exams(@employee)
      puts @exams.count
      
  end
  
  def create    
    render 'new'
  end

  def destroy
  end
end

