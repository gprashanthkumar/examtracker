class Employee < ActiveRecord::Base
   self.table_name = "public.employees"
  def self.get_employee(username)
    @employee ||= Java::HarbingerSdkData::Employee.withUserName(username, @entity_manager)
    return @employee
  end
end