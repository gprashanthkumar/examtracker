
class SessionsController < ApplicationController
  layout 'examtracker_layout'
   before_filter :general_authentication
  before_filter :get_entity_manager
  def new
  end
  
  def get_sessions
    session.delete 'init' 
      @employee = Employee.get_employee(session[:username])   
      @h = Hash[@employee.first.attributes.map { |k, v| [ k.to_sym, v ] }]
      puts @h.to_s;
  end
  
  def create    
    render 'new'
  end

  def destroy
  end
end

