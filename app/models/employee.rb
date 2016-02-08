class Employee < ActiveRecord::Base
   self.table_name = "public.employees"
  def self.get_employee(username)
    puts username 
    if @employee == nil || @employee.name != username
      @employee = nil;
      @employee = Java::HarbingerSdkData::Employee.withUserName(username, @entity_manager)
    end
	@employee ||= Java::HarbingerSdkData::Employee.withUserName(username, @entity_manager)
	puts @employee.to_json
	
    #@employee = self.where("name = ?",username).first
    return @employee
  end
end