class Employee < ActiveRecord::Base
   self.table_name = "public.employees"
  def self.get_employee(username)
    puts username
	@employee ||= Java::HarbingerSdkData::Employee.withUserName(username, @entity_manager)
	puts "kumar start"
	puts @employee.to_json
	puts "kumar end"
    #@employee = self.where("name = ?",username).first
    return @employee
  end
end