class Rad_Exam < ActiveRecord::Base
   self.table_name = "public.rad_exams"
   scope :join_Main, -> { 
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
    .joins("left join rad_pacs_metadata rpmd on rpmd.rad_exam_id = rad_exams.id") 
    .joins("left join rad_exam_times ret on ret.rad_exam_id =  rad_exams.id")
    .select("p.name patient_name,p.birthdate,pmrn.mrn,proc.code,proc.description,modality,res.name as resource_name
     ,uet.event_type as graph_status
    ,uet.event_type as current_status
    ,CASE WHEN s.name IS NULL THEN s.site ELSE s.name END  site_name
     ,CASE WHEN sc.name IS NULL THEN sc.site_class ELSE sc.name END  patient_class
     ,pt.patient_type
     ,CASE WHEN sloc.location IS NULL THEN '' ELSE sloc.location END 
     || CASE WHEN ssloc.room IS NULL THEN '' ELSE ssloc.room END 
      || CASE WHEN ssloc.bed IS NULL THEN '' ELSE ssloc.bed END  patient_location_at_exam
     ,CASE WHEN rad_exams.rad_exam_department_id IS NULL THEN '' WHEN red.description IS NULL THEN red.department ELSE red.description END  radiology_department
     ,CASE WHEN empop.name IS NULL THEN '' ELSE empop.name END  ordering_provider
     ,CASE WHEN empsched.name IS NULL THEN '' ELSE empsched.name END  scheduler
     ,CASE WHEN emptech.name IS NULL THEN '' ELSE emptech.name END  technologist
     ,Case WHEN rpmd.image_count IS NULL THEN 0 ELSE rpmd.image_count END  pacs_image_count
 ,CASE WHEN ret.appointment is null then ret.appointment else ret.appointment END appt_time
 ,CASE WHEN ret.sign_in is null then ret.sign_in else ret.sign_in END sign_in
,CASE WHEN ret.check_in is null then ret.check_in else ret.check_in END check_in
,CASE WHEN ret.begin_exam is null then ret.begin_exam else ret.begin_exam END begin_exam
,CASE WHEN ret.end_exam is null then ret.end_exam else ret.end_exam END end_exam
     ,rad_exams.*")      
  }   
  
   scope :Radiologist, -> { 
    joins("LEFT JOIN rad_reports rr ON rr.rad_exam_id = rad_exams.id" )   
   }
  def self.get_rad_exams(employeeid)
    #self.where({patient_mrn_id: mrn}).order("created_at desc").first
    self.join_Main.order("id desc").all;
  end
  def self.get_tech_exams(employeeid)
    
    s = self.join_Main.Radiologist.where("( (rr.rad1_id = ?) or (rr.rad2_id = ?) or  (rr.rad3_id = ?) or (rr.rad4_id = ?)) ",employeeid,employeeid,employeeid,employeeid).order("id desc").all ;
   #s.where("name ILIKE ?", wildcard_name) unless params[:patient_name].blank?
   #s.where("rad_reports.rad1_id = ? or rad_reports.rad2_id = ? or rad_reports.rad3_id = ? or rad_reports.rad4_id = ? ", employeeid, employeeid, employeeid, employeeid) ;
   #unless employeeid.blank?
    #s.order("id desc").all;
    
    return s
  end
end