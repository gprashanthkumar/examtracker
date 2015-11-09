class Employee < ActiveRecord::Base
   #self.table_name = "public.employees"
  def self.get_employee
    @employee ||= Java::HarbingerSdkData::Employee.withUserName(session[:username], @entity_manager)
    return @employee
  end
end