class Employee < ActiveRecord::Base
  def self.get_employee
    @employee ||= Java::HarbingerSdkData::Employee.withUserName(session[:username], @entity_manager)
    return @employee
  end
end