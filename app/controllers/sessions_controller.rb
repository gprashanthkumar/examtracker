
class SessionsController < ApplicationController
  layout 'examtracker_layout'
  before_filter :general_authentication
  before_filter :get_entity_manager
  def new
  end
  
  def  radiologist   
    redirect_to "/radiologist"
  end
  
  def  technologist   
    #redirect_to url_for(:controller => HomeController, :action => technologist)    
    redirect_to "/technologist"
    
  end
  def  scheregistrar   
    #redirect_to url_for(:controller => HomeController, :action => technologist)    
    redirect_to "/sche-registrar"
    
  end
  
  def get_sessions
    session.delete 'init' 
    @employee = 0;  
    @employee = Employee.get_employee(session[:username])   
      #@exams = Rad_Exam.get_rad_exams(@employee.id)
      @exams = Rad_Exam.get_tech_exams(@employee.id)
      
     # puts @exams.count
      puts @exams.to_json
      
  end
  
  def create    
    render 'new'
  end

  def destroy
  end
end

