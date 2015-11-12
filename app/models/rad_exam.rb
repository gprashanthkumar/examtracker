class Rad_Exam < ActiveRecord::Base
   self.table_name = "public.rad_exams"
  scope :join_patient_mrns, -> { joins("LEFT JOIN patient_mrns pmrn ON pmrn.patient_id = rad_exams.patient_mrn_id" ) }
  #scope :join_tech_employees_name, -> { joins("LEFT JOIN patient_mrns pmrn ON pmrn.patient_id = patients.id" ) }
  #scope :join_patient_mrns, -> { joins("LEFT JOIN patient_mrns pmrn ON pmrn.patient_id = patients.id" ) }
  #scope :join_cdc_mrn, -> { joins("LEFT JOIN patient_mrns cdc_mrn ON cdc_mrn.patient_id = patients.id AND cdc_mrn.external_system_id = ( select id from external_systems where external_system = 'CDC')") }
  #scope :join_observation, -> { joins("LEFT JOIN ebola_observations obs ON obs.patient_mrn_id = pmrn.id LEFT JOIN ebola_observation_types eot ON eot.id = obs.observation_type_id LEFT JOIN ebola_observation_statuses eos ON eos.id = obs.observation_status_id") }
  #scope :join_demos, -> { joins("LEFT OUTER JOIN patient_demos pdemos ON pdemos.patient_mrn_id = pmrn.id") }
  
  def self.get_rad_exams(employeeid)
    #self.where({patient_mrn_id: mrn}).order("created_at desc").first
    self.order("id desc").all;
  end
end