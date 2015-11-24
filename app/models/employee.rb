class Employee < ActiveRecord::Base
   self.table_name = "public.employees"
  def self.get_employee(username)
    #@employee ||= Java::HarbingerSdkData::Employee.withUserName(username, @entity_manager)
    @employee = self.select(employees.*).where("name = ?",username).first
    return @employee
  end
end