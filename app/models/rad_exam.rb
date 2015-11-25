class Rad_Exam < ActiveRecord::Base
  self.table_name = "public.rad_exams"
  #Scopes
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
    ,sc.trauma
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
     ,CASE WHEN ret.order_arrival is null then ret.order_arrival else ret.order_arrival END order_arrival
     ,rad_exams.*")      
  }   
  
  scope :Radiologist_Transcript, -> { 
    joins("LEFT JOIN rad_reports rr ON rr.rad_exam_id = rad_exams.id" )
    .joins("left join rad_exam_personnel repp on repp.rad_exam_id = rad_exams.id") 
  }
  
  scope :Tech_sched_Other, -> { 
    joins("left join rad_exam_personnel repp on repp.rad_exam_id = rad_exams.id") 
  }
  scope :Rad_report_event, -> {
    joins("LEFT JOIN rad_reports rrff ON rrff.rad_exam_id = rad_exams.id" )
    .joins("LEFT JOIN rad_reports rrlf ON rrlf.rad_exam_id = rad_exams.id" )
    .select("rrff.report_event as first_final, rrlf.report_event as last_final")
  }
   scope :Radiologist_Reports, -> { 
    joins("inner JOIN rad_reports rr ON rr.rad_exam_id = rad_exams.id" )
    .joins("LEFT join external_system_statuses ess1 on ess1.id = rr.report_status_id") 
    .joins("LEFT join universal_event_types uet1 on uet1.id = ess1.universal_event_type_id")
    .joins("LEFT join employees rademp1 on rademp1.id = rr.rad1_id")
    .joins("left join employees rademp2 on rademp2.id = rr.rad2_id")
    .select("rr.report_event as report_time,rr.report_impression,rr.report_body
,uet1.event_type as status,rademp1.name as rad1_name,rademp1.name as rad2_name")
    
  }
  
  #definitions
  def self.get_rad_exams(employeeid,accessions,current_status)
    #self.where({patient_mrn_id: mrn}).order("created_at desc").first
    accfilter = "";
    csfilter = "";
    accfilter = accessions.to_s unless accessions.blank?;
    accfilter = stringArray_to_string(accfilter);
    
   
    csfilter = current_status.to_s unless current_status.blank?;
    csfilter = stringArray_to_string(csfilter);
    
    rad_exams = self.join_Main.Radiologist_Transcript.where("( (rr.rad1_id = ?) or (rr.rad2_id = ?) or  (rr.rad3_id = ?) or (rr.rad4_id = ?)) or (repp.performing_id = ?) ",employeeid,employeeid,employeeid,employeeid,employeeid) .order("id desc").all;              
    #rad_exams = rad_exams.where("accession in (?)",accessions.to_s.gsub!("[","").gsub!("]","")).order("id desc").all unless accessions.blank?; 
    rad_exams = rad_exams.where("accession in ( " + accfilter +")" ).all unless accessions.blank?; 
    rad_exams = rad_exams.where("uet.event_type in ( " + csfilter +")" ).all unless current_status.blank?; 
    
    return rad_exams;
  end
  def self.get_tech_exams(employeeid,accessions,current_status)
    accfilter = "";
    csfilter = "";
    
    accfilter = accessions.to_s unless accessions.blank?;
    accfilter = stringArray_to_string(accfilter);   
    csfilter = current_status.to_s unless current_status.blank?;
    csfilter = stringArray_to_string(csfilter);
    tech_exams = self.join_Main.Tech_sched_Other.where("( 
(repp.performing_id = ?) OR
(repp.scheduler_id  = ?) OR
(repp.technologist_id  = ?)  OR
(repp.assisting_tech1_id  = ?)  OR
(repp.assisting_tech2_id  = ?)  OR
(repp.assisting_tech3_id  = ?)  OR
(repp.attending_id  = ?)  OR
(repp.ordering_id  = ?)  OR
(repp.authorizing_id  = ?) ) ",employeeid,employeeid,employeeid,employeeid,employeeid,employeeid,employeeid,employeeid,employeeid).order("id desc").all ;   
    tech_exams = tech_exams.where("accession in ( " + accfilter +")" ).all unless accessions.blank?; 
    tech_exams = tech_exams.where("uet.event_type in ( " + csfilter +")" ).all unless current_status.blank?; 
    
    return tech_exams;
  end
  
  def self.get_sched_exams(employeeid,accessions,current_status)
    accfilter = "";
    csfilter = "";
    
    accfilter = accessions.to_s unless accessions.blank?;
    accfilter = stringArray_to_string(accfilter);   
    csfilter = current_status.to_s unless current_status.blank?;
    csfilter = stringArray_to_string(csfilter);
    
    sched_exams = self.join_Main.Tech_sched_Other.where("( 
(repp.scheduler_id  = ?) OR
(repp.signin_id  = ?) OR
(repp.checkin_id  = ?) ) ",employeeid,employeeid,employeeid).order("id desc").all ;   
    sched_exams = sched_exams.where("accession in ( " + accfilter +")" ).all unless accessions.blank?; 
    sched_exams = sched_exams.where("uet.event_type in ( " + csfilter +")" ).all unless current_status.blank?; 
    return sched_exams;
  end
  
  def self.get_trans_exams(employeeid,accessions,current_status)
    accfilter = "";
    csfilter = "";
    
    accfilter = accessions.to_s unless accessions.blank?;
    accfilter = stringArray_to_string(accfilter);   
    csfilter = current_status.to_s unless current_status.blank?;
    csfilter = stringArray_to_string(csfilter);
    
    trans_exams = self.join_Main.Radiologist_Transcript.where("( 
(repp.scheduler_id  = ?) OR
(repp.signin_id  = ?) OR
(repp.checkin_id  = ?) OR 
(rr..transcriptionist_id  = ?)
) ",employeeid,employeeid,employeeid,employeeid).order("id desc").all ;   
    trans_exams = trans_exams.where("accession in ( " + accfilter +")" ).all unless accessions.blank?; 
    trans_exams = trans_exams.where("uet.event_type in ( " + csfilter +")" ).all unless current_status.blank?; 
    return trans_exams;
  end
  
  def self.get_other_exams(employeeid,accessions,current_status)
    accfilter = "";
    csfilter = "";
    
    accfilter = accessions.to_s unless accessions.blank?;
    accfilter = stringArray_to_string(accfilter);   
    csfilter = current_status.to_s unless current_status.blank?;
    csfilter = stringArray_to_string(csfilter);
    others_exams = self.join_Main.Tech_sched_Other.where("( 
(repp.attending_id  = ?)  OR
(repp.ordering_id  = ?)  OR
(repp.authorizing_id  = ?)
 ) ",employeeid,employeeid,employeeid).order("id desc").all ;  
    others_exams = others_exams.where("accession in ( " + accfilter +")" ).all unless accessions.blank?; 
    others_exams = others_exams.where("uet.event_type in ( " + csfilter +")" ).all unless current_status.blank?; 
    
    return others_exams;
  end

   
  def self.get_exams_all(employeeid)
    #self.where({patient_mrn_id: mrn}).order("created_at desc").first
    self.join_Main.order("id desc").all;
  end
  
  def self.get_exams_search(employeeid,accession)    
    puts "kumnar " + accession;
    exams_search = self.join_Main;
    exams_search = exams_search.where("accession in ( " +  accession +")" ).all unless accession.blank?;
    
    return exams_search;
  end
  
  #This is main query from ra_exams details of particular accession
  def self.get_accession_detail(accessionid)
    accession = self.join_Main.Rad_report_event.where(" rad_exams.accession = ? ",accessionid).first;
    return accession;
  end
  
  def self.get_accession_reports(accessionid)
     reports = self.join_Main.Radiologist_Reports.where(" rad_exams.accession = ? ",accessionid).order("id desc").all;
    return reports;
  end
  
  def self.stringArray_to_string(arraystring)
    arraystring.gsub! "[","";
    arraystring.gsub! "]","";
    arraystring.gsub!  "\", \"", "', '";
    arraystring.gsub!  "\"", "'";
    return arraystring;
  end
end
