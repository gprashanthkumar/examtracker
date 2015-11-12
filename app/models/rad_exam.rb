class Rad_Exam < ActiveRecord::Base
   self.table_name = "public.rad_exams"
 
  
  def self.get_rad_exams(employeeid)
    #self.where({patient_mrn_id: mrn}).order("created_at desc").first
    self.order("id desc").all;
  end
end