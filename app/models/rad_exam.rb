class Rad_Exam < ActiveRecord::Base
   self.table_name = "public.rad_exams"
   scope :join_patient_mrns, -> { 
    joins("LEFT JOIN patient_mrns pmrn ON pmrn.id = rad_exams.patient_mrn_id" )
    .joins("LEFT JOIN patients p ON p.id = pmrn.patient_id" )
    .joins("LEFT JOIN procedures proc on proc.id = rad_exams.procedure_id ")
    .joins("LEFT JOIN resources res on res.id = rad_exams.resource_id ")
    .joins("LEFT JOIN modalities mod on mod.id = res.modality_id ")
    .joins("LEFT join external_system_statuses ess on ess.id = rad_exams.current_status_id ")
    .joins("LEFT join universal_event_types uet on uet.id = ess.universal_event_type_id ")
    .joins("LEFT join  sites s on s.id = rad_exams.site_id")
    .joins("LEFT join  site_classes sc on sc.id = rad_exams.site_class_id")
    .joins("LEFT join patient_types pt on pt.id = sc.patient_type_id")    
    .joins("LEFT join site_sublocations ssloc on ssloc.id = rad_exams.site_sublocation_id")
    .joins("LEFT join site_locations sloc on sloc.id = ssloc.site_location_id")    
    .joins("LEFT join rad_exam_departments red on red.id = rad_exams.rad_exam_department_id")    
    .joins("left join rad_exam_personnel repop on repop.rad_exam_id = rad_exams.id") 
    .joins("left join employees empop on empop.id = repop.ordering_id") 
    .joins("left join rad_exam_personnel repsched on repsched.rad_exam_id = rad_exams.id") 
    .joins("left join employees empsched on empsched.id = repsched.scheduler_id") 
    .joins("left join rad_exam_personnel repstech on repstech.rad_exam_id = rad_exams.id") 
    .joins("left join employees emptech on emptech.id = repstech.technologist_id")     
    .select("p.name,p.birthdate,pmrn.mrn,proc.code,proc.description,modality,res.name as resource_name
     ,uet.event_type as current_status,CASE WHEN s.name IS NULL THEN s.site ELSE s.name END  site_name
     ,CASE WHEN sc.name IS NULL THEN sc.site_class ELSE sc.name END  patient_class
     ,pt.patient_type
     ,CASE WHEN sloc.location IS NULL THEN '' ELSE sloc.location END 
     || CASE WHEN ssloc.room IS NULL THEN '' ELSE ssloc.room END 
      || CASE WHEN ssloc.bed IS NULL THEN '' ELSE ssloc.bed END  patient_location_at_exam
     ,CASE WHEN rad_exams.rad_exam_department_id IS NULL THEN '' WHEN red.description IS NULL THEN red.department ELSE red.description END  radiology_department
     ,CASE WHEN empop.name IS NULL THEN '' ELSE empop.name END  ordering_provider
     ,CASE WHEN empsched.name IS NULL THEN '' ELSE empsched.name END  scheduler
     ,CASE WHEN emptech.name IS NULL THEN '' ELSE emptech.name END  technologist
     ,rad_exams.*")    
  } 
  #scope :join_tech_employees_name, -> { joins("LEFT JOIN patient_mrns pmrn ON pmrn.patient_id = patients.id" ) }
  #scope :join_patient_mrns, -> { joins("LEFT JOIN patient_mrns pmrn ON pmrn.patient_id = patients.id" ) }
  #scope :join_cdc_mrn, -> { joins("LEFT JOIN patient_mrns cdc_mrn ON cdc_mrn.patient_id = patients.id AND cdc_mrn.external_system_id = ( select id from external_systems where external_system = 'CDC')") }
  #scope :join_observation, -> { joins("LEFT JOIN ebola_observations obs ON obs.patient_mrn_id = pmrn.id LEFT JOIN ebola_observation_types eot ON eot.id = obs.observation_type_id LEFT JOIN ebola_observation_statuses eos ON eos.id = obs.observation_status_id") }
  #scope :join_demos, -> { joins("LEFT OUTER JOIN patient_demos pdemos ON pdemos.patient_mrn_id = pmrn.id") }
  
  def self.get_rad_exams(employeeid)
    #self.where({patient_mrn_id: mrn}).order("created_at desc").first
    self.join_patient_mrns.order("id desc").all;
  end
end