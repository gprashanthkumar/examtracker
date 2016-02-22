class Rad_Exam < ActiveRecord::Base
  self.table_name = "public.rad_exams"
 
  #Scopes
  #This is the main scope to which other scopes are combined
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
    .joins("LEFT JOIN rad_reports rr ON rr.rad_exam_id = rad_exams.id" )
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
     ,CASE WHEN ret.schedule_event is null then ret.schedule_event else ret.schedule_event END sched_time     
     ,CASE WHEN ret.appointment is null then ret.appointment else ret.appointment END appt_time
     ,CASE WHEN ret.sign_in is null then ret.sign_in else ret.sign_in END sign_in
     ,CASE WHEN ret.check_in is null then ret.check_in else ret.check_in END check_in
     ,CASE WHEN ret.begin_exam is null then ret.begin_exam else ret.begin_exam END begin_exam
     ,CASE WHEN ret.end_exam is null then ret.end_exam else ret.end_exam END end_exam
     ,CASE WHEN ret.order_arrival is null then ret.order_arrival else ret.order_arrival END order_arrival
     ,CASE WHEN rr.report_event is null then rr.report_event else rr.report_event END report_time 
     ,rad_exams.*")      
  }   
  
  #This is the join scope for grids
  scope :Rad_Tech_Sched_Trans_Other, -> { 
    joins("left join rad_exam_personnel repp on repp.rad_exam_id = rad_exams.id") 
  }
  #This is the join scope for accession details which is final exam report time this missing in main scope
  scope :Rad_report_event, -> {
    joins("LEFT JOIN rad_reports rrff ON rrff.rad_exam_id = rad_exams.id and rrff.id = rad_exams.first_final_report_id " )
    .joins("LEFT JOIN rad_reports rrlf ON rrlf.rad_exam_id = rad_exams.id and rrlf.id = rad_exams.last_final_report_id " )
    .joins("LEFT join employees rademp1 on rademp1.id = rrlf.rad1_id")
    .joins("left join employees rademp2 on rademp2.id = rrlf.rad2_id")    
    .select("rrff.report_event as first_final, rrlf.report_event as last_final,rademp1.name as rad1_name,rademp1.name as rad2_name")
  }
  #This is the scope to give list of reports 
  scope :Radiologist_Reports, -> { 
    joins("LEFT join external_system_statuses ess1 on ess1.id = rr.report_status_id") 
    .joins("LEFT join universal_event_types uet1 on uet1.id = ess1.universal_event_type_id")
    .joins("LEFT join employees rademp1 on rademp1.id = rr.rad1_id")
    .joins("left join employees rademp2 on rademp2.id = rr.rad2_id")
    .select("rr.report_impression,rr.report_body,uet1.event_type as status,rademp1.name as rad1_name,rademp1.name as rad2_name")
    
  }  
  
  def self.get_exams_search(employeeid,params,myreports = false,myexams = false,myorders = false)    
     
    exams_search = self.join_Main.Rad_Tech_Sched_Trans_Other;  
    if (myreports == true)
      exams_search = exams_search.where("( (rr.rad1_id = ?) or (rr.rad2_id = ?) or  (rr.rad3_id = ?) or (rr.rad4_id = ?)) ",employeeid,employeeid,employeeid,employeeid).all;
    end
    
    if (myexams == true)      
      exams_search = exams_search.where("( (repp.performing_id = ?) or (repp.technologist_id = ?) or  (repp.scheduler_id = ?) ) ",employeeid,employeeid,employeeid).all;
    end
    
    if (myorders == true)        
      exams_search = exams_search.where("( (repp.attending_id = ?) or (repp.ordering_id = ?) or  (repp.authorizing_id = ?) ) ",employeeid,employeeid,employeeid).all;        
    end 
    
    if ((params[:visit] != "") && !(params[:visit].nil?) && !(params[:visit].blank?)) 
      exams_search = exams_search.joins("Left JOIN visits v on v.id = rad_exams.visit_id")
      exams_search = exams_search.where(" (v.visit_number ilike ?)  " , "%#{params[:visit]}%" ).all ;
    end
    
    if ((params[:order_id] != "") && !(params[:order_id].nil?) && !(params[:order_id].blank?)) 
      exams_search = exams_search.joins("Left JOIN orders o on o.id = rad_exams.order_id")
      exams_search = exams_search.where(" (o.order_number ilike ?)  " , "%#{params[:order_id]}%" ).all ;
    end
    
    if ((params[:accession] != "") && !(params[:accession].nil?) && !(params[:accession].blank?))            
      exams_search = exams_search.where("accession ilike ?", "%#{params[:accession]}%" ).all ;
    end 
     
    if ((params[:patient_type] != "") && !(params[:patient_type].nil?) && !(params[:patient_type].blank?))            
      exams_search = exams_search.where("pt.id = ?", params[:patient_type] ).all ;
    end 
    if ((params[:mrn] != "") && !(params[:mrn].nil?) && !(params[:mrn].blank?))            
      exams_search = exams_search.where("pmrn.mrn ilike ?", "%#{params[:mrn]}%" ).all ;
    end      
    if ((params[:patient_name] != "") && !(params[:patient_name].nil?) && !(params[:patient_name].blank?))          
      exams_search = exams_search.where("p.name ilike ?", "%#{params[:patient_name]}%" ).all ;
    end      
      
    if ((params[:modality] != "") && !(params[:modality].nil?) && !(params[:modality].blank?))          
      exams_search = exams_search.where("modality ilike ?", "%#{params[:modality]}%" ).all ;
    end
      
    if ((params[:code] != "") && !(params[:code].nil?) && !(params[:code].blank?))          
      exams_search = exams_search.where("  concat(proc.code, proc.description)  ilike ?", "%#{params[:code]}%" ).all ;
    end
      
    if ((params[:resource_name] != "") && !(params[:resource_name].nil?) && !(params[:resource_name].blank?))          
      exams_search = exams_search.where("  res.name  ilike ?", "%#{params[:resource_name]}%" ).all ;
    end
      
    if ((params[:rad_exam_dept] != "") && !(params[:rad_exam_dept].nil?) && !(params[:rad_exam_dept].blank?))          
      exams_search = exams_search.where("  red.description  ilike ?", "%#{params[:rad_exam_dept]}%" ).all ;
    end
      
    if ((params[:current_status] != "") && !(params[:current_status].nil?) && !(params[:current_status].blank?))          
      exams_search = exams_search.where("  uet.event_type  ilike ?", "%#{params[:current_status]}%" ).all ;
    end
      
    if ((params[:patient_exam_location] != "") && !(params[:patient_exam_location].nil?) && !(params[:patient_exam_location].blank?))          
      exams_search = exams_search.where("  patient_location_at_exam  ilike ?", "%#{params[:patient_exam_location]}%" ).all ;
    end
      
    if ((params[:site_name] != "") && !(params[:site_name].nil?) && !(params[:site_name].blank?))          
      exams_search = exams_search.where(" ((s.name ilike ?)  or (s.site ilike ?))", "%#{params[:site_name]}%" , "%#{params[:site_name]}%" ).all ;
    end  
        
   
    
    return exams_search;
  end
  
   def self.get_exams_search_sdk(employeeid,params,myreports = false,myexams = false,myorders = false)    
     
    puts "inside get_exams_search_sdk "
     #exams_search = self.join_Main.Rad_Tech_Sched_Trans_Other; 
    @mysdk1 = " ";  
    
      q1 = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager) 
  
    qmyreports = nil;
    qmyexams =nil;
    qmyorders = nil;       
 
    
    puts q1.toSQL;
    return q1.list.to_a ;

  
  end
  
  #Definition:  This is the definition called to return list of  exam records matching passed eccessionid list idList
  def self.get_exams_search_by_id_array(idList)
    exams_search = self.join_Main.Rad_Tech_Sched_Trans_Other;  
    exams_search = exams_search.where("rad_exams.id in (?)", idList ).order("id desc").all ;
    return exams_search;    
  end
  
  #Definition: This is main query from ra_exams details of for passed accessionid as accession of the exam
  def self.get_accession_detail(accessionid)
  
    accession = self.join_Main.Rad_report_event.where(" rad_exams.accession = ? ",accessionid).all;     
    return accession;
  end
  
  #Definitions: This is the definition to return resultset of reports records for passed accessionid as accession of the reports
  def self.get_accession_reports(accessionid)
    reports = self.join_Main.Radiologist_Reports.where(" rad_exams.accession = ? ",accessionid).order("id desc").all;
    return reports;
  end
  
  #Definitions: This is the  utility definition 
  #(this can be moved out of this module to any other, as long as its accessible from this module).
  def self.string_array_to_string(arraystring)
    arraystring.gsub! "[","";
    arraystring.gsub! "]","";
    arraystring.gsub!  "\", \"", "', '";
    arraystring.gsub!  "\"", "'";
    return arraystring;
  end 

  
  def self.radRoleData(employeeid,accessions,current_status)
  @mysdk1 = " ";  
   q1 = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager)  
   
    puts "<----kumar --->" + (accessions.blank?).to_s + " ---" + (current_status.blank?).to_s
       
 #q1.where (q1.and(q1.in(".accession", accessions), q1.equal("1","1")))unless (accessions.blank? &&  current_status.blank?)
  #q1.where(q1.or( [q1.ilike(".procedure.code","MR%"),q1.regex(".procedure.code","^CT.+MOD1$")]))
  if ( (accessions.blank? == false) && (current_status.blank? == false) ) 
   
        
   q1.where(q1.and(
          [
            q1.in(".accession", accessions), q1.in(".currentStatus.universalEventType.eventType", current_status),
            q1.or(
              [
                q1.equal(".currentReport.rad1.id",employeeid),q1.equal(".currentReport.rad2.id",employeeid),q1.equal(".currentReport.rad3.id",employeeid),q1.equal(".currentReport.rad4.id",employeeid),q1.equal(".radExamPersonnel.performingId",employeeid)
              ]
            )         
         ] 
       ));
   
  elsif (accessions.blank? == false)
   
     q1.where(q1.and(
          [
            q1.in(".accession", accessions),
            q1.or(
              [
                q1.equal(".currentReport.rad1.id",employeeid),q1.equal(".currentReport.rad2.id",employeeid),q1.equal(".currentReport.rad3.id",employeeid),q1.equal(".currentReport.rad4.id",employeeid),q1.equal(".radExamPersonnel.performingId",employeeid)
              ]
            )         
         ] 
       ));
  elsif (current_status.blank? == false)
   
      q1.where(q1.and(
                        [
                          q1.in(".currentStatus.universalEventType.eventType", current_status),
                          q1.or(
                            [
                              q1.equal(".currentReport.rad1.id",employeeid),q1.equal(".currentReport.rad2.id",employeeid),q1.equal(".currentReport.rad3.id",employeeid),q1.equal(".currentReport.rad4.id",employeeid),q1.equal(".radExamPersonnel.performingId",employeeid)
                            ]
                          )         
                       ] 
       ));
  else 
    #none
    puts "Both are BLANK  (default) !!!" + employeeid.to_s
   #q1.where(q1.equal(".radExamPersonnel.performingId",employeeid) )
   q1.where(q1.or ( [
         q1.equal(".currentReport.rad1.id",employeeid),q1.equal(".currentReport.rad2.id",employeeid),q1.equal(".currentReport.rad3.id",employeeid),q1.equal(".currentReport.rad4.id",employeeid)]  )
     )
  end
#q1.where (q1.and([q1.in(".accession", accessions), q1.in(".currentStatus.universalEventType.eventType", current_status)] ) unless (accessions.blank? &&  current_status.blank?);

   @mysdk1=  q1.list.to_a 
    
  end
  
   def self.techRoleData(employeeid,accessions,current_status)
  @mysdk1 = " ";  
   q1 = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager)  
   
    puts "<----kumar --->" + (accessions.blank?).to_s + " ---" + (current_status.blank?).to_s
       
 #q1.where (q1.and(q1.in(".accession", accessions), q1.equal("1","1")))unless (accessions.blank? &&  current_status.blank?)
  #q1.where(q1.or( [q1.ilike(".procedure.code","MR%"),q1.regex(".procedure.code","^CT.+MOD1$")]))
  if ( (accessions.blank? == false) && (current_status.blank? == false) ) 
   
        
   q1.where(q1.and(
          [
            q1.in(".accession", accessions), q1.in(".currentStatus.universalEventType.eventType", current_status),
            q1.or(
              [
                q1.equal(".radExamPersonnel.assistingTech1.id",employeeid),q1.equal(".radExamPersonnel.assistingTech2.id",employeeid),q1.equal(".radExamPersonnel.assistingTech3.id",employeeid),q1.equal(".radExamPersonnel.technologist.id",employeeid)
              ]
            )         
         ] 
       ));
   
  elsif (accessions.blank? == false)
   
     q1.where(q1.and(
          [
            q1.in(".accession", accessions),
            q1.or(
              [
                q1.equal(".radExamPersonnel.assistingTech1.id",employeeid),q1.equal(".radExamPersonnel.assistingTech2.id",employeeid),q1.equal(".radExamPersonnel.assistingTech3.id",employeeid),q1.equal(".radExamPersonnel.technologist.id",employeeid)
              ]
            )         
         ] 
       ));
  elsif (current_status.blank? == false)
   
      q1.where(q1.and(
                        [
                          q1.in(".currentStatus.universalEventType.eventType", current_status),
                          q1.or(
                            [
                               q1.equal(".radExamPersonnel.assistingTech1.id",employeeid),q1.equal(".radExamPersonnel.assistingTech2.id",employeeid),q1.equal(".radExamPersonnel.assistingTech3.id",employeeid),q1.equal(".radExamPersonnel.technologist.id",employeeid)
                            ]
                          )         
                       ] 
       ));
  else 
    #none
    puts "Both are BLANK  (default) !!!" + employeeid.to_s
   #q1.where(q1.equal(".radExamPersonnel.performingId",employeeid) )
   q1.where(q1.or(
              [
                   q1.equal(".radExamPersonnel.assistingTech1.id",employeeid),q1.equal(".radExamPersonnel.assistingTech2.id",employeeid),q1.equal(".radExamPersonnel.assistingTech3.id",employeeid),q1.equal(".radExamPersonnel.technologist.id",employeeid)            
              ] 
           )
          )
  end
#q1.where (q1.and([q1.in(".accession", accessions), q1.in(".currentStatus.universalEventType.eventType", current_status)] ) unless (accessions.blank? &&  current_status.blank?);

   @mysdk1=  q1.list.to_a 
    
  end
  
   def self.schedRegRoleData(employeeid,accessions,current_status)
  @mysdk1 = " ";  
   q1 = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager)  
   
    puts "<----kumar --->" + (accessions.blank?).to_s + " ---" + (current_status.blank?).to_s
       
 #q1.where (q1.and(q1.in(".accession", accessions), q1.equal("1","1")))unless (accessions.blank? &&  current_status.blank?)
  #q1.where(q1.or( [q1.ilike(".procedure.code","MR%"),q1.regex(".procedure.code","^CT.+MOD1$")]))
  if ( (accessions.blank? == false) && (current_status.blank? == false) ) 
   
        
   q1.where(q1.and(
          [
            q1.in(".accession", accessions), q1.in(".currentStatus.universalEventType.eventType", current_status),
            q1.or(
              [
                q1.equal(".radExamPersonnel.scheduler.id",employeeid),q1.equal(".radExamPersonnel.checkin.id",employeeid),q1.equal(".radExamPersonnel.beginExam.id",employeeid)
                
              ]
            )         
         ] 
       ));
   
  elsif (accessions.blank? == false)
   
     q1.where(q1.and(
          [
            q1.in(".accession", accessions),
            q1.or(
              [
                q1.equal(".currentReport.rad1.id",employeeid),q1.equal(".currentReport.rad2.id",employeeid),q1.equal(".currentReport.rad3.id",employeeid),q1.equal(".currentReport.rad4.id",employeeid),q1.equal(".radExamPersonnel.performingId",employeeid)
              ]
            )         
         ] 
       ));
  elsif (current_status.blank? == false)
   
      q1.where(q1.and(
                        [
                          q1.in(".currentStatus.universalEventType.eventType", current_status),
                          q1.or(
                            [
                              q1.equal(".currentReport.rad1.id",employeeid),q1.equal(".currentReport.rad2.id",employeeid),q1.equal(".currentReport.rad3.id",employeeid),q1.equal(".currentReport.rad4.id",employeeid),q1.equal(".radExamPersonnel.performingId",employeeid)
                            ]
                          )         
                       ] 
       ));
  else 
    #none
    puts "Both are BLANK  (default) !!!" + employeeid.to_s
   #q1.where(q1.equal(".radExamPersonnel.performingId",employeeid) )
   q1.where(q1.or ( [
         q1.equal(".currentReport.rad1.id",employeeid),q1.equal(".currentReport.rad2.id",employeeid),q1.equal(".currentReport.rad3.id",employeeid),q1.equal(".currentReport.rad4.id",employeeid)]  )
     )
  end
#q1.where (q1.and([q1.in(".accession", accessions), q1.in(".currentStatus.universalEventType.eventType", current_status)] ) unless (accessions.blank? &&  current_status.blank?);

   @mysdk1=  q1.list.to_a 
    
  end
  
  def self.transRoleData(employeeid,accessions,current_status)
  @mysdk1 = " ";  
   q1 = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager)  
   
    puts "<----kumar --->" + (accessions.blank?).to_s + " ---" + (current_status.blank?).to_s
       
 #q1.where (q1.and(q1.in(".accession", accessions), q1.equal("1","1")))unless (accessions.blank? &&  current_status.blank?)
  #q1.where(q1.or( [q1.ilike(".procedure.code","MR%"),q1.regex(".procedure.code","^CT.+MOD1$")]))
  if ( (accessions.blank? == false) && (current_status.blank? == false) ) 
   
        
   q1.where(q1.and(
          [
            q1.in(".accession", accessions), q1.in(".currentStatus.universalEventType.eventType", current_status),
            q1.equal(".currentReport.transcriptionist.id",employeeid)         
         ] 
       ));
   
  elsif (accessions.blank? == false)
   
     q1.where(q1.and(
          [
            q1.in(".accession", accessions),
            q1.equal(".currentReport.transcriptionist.id",employeeid)                             
         ] 
       )
     );
  elsif (current_status.blank? == false)
   
      q1.where(q1.and(
                        [
                          q1.in(".currentStatus.universalEventType.eventType", current_status),
                         q1.equal(".currentReport.transcriptionist.id",employeeid)                
                       ] 
       ));
  else 
    #none
    puts "Both are BLANK  (default) !!!" + employeeid.to_s
   #q1.where(q1.equal(".radExamPersonnel.performingId",employeeid) )
   q1.where(
     q1.equal(".currentReport.transcriptionist.id",employeeid)         
     )
  end

   @mysdk1=  q1.list.to_a 
    
  end
  
  def self.orderingRoleData(employeeid,accessions,current_status)
  @mysdk1 = " ";  
   q1 = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager)  
   
    puts "<----kumar --->" + (accessions.blank?).to_s + " ---" + (current_status.blank?).to_s
       
 #q1.where (q1.and(q1.in(".accession", accessions), q1.equal("1","1")))unless (accessions.blank? &&  current_status.blank?)
  #q1.where(q1.or([q1.ilike(".procedure.code","MR%"),q1.regex(".procedure.code","^CT.+MOD1$")]))
  if ( (accessions.blank? == false) && (current_status.blank? == false) ) 
   
        
   q1.where(q1.and(
          [
            q1.in(".accession", accessions), q1.in(".currentStatus.universalEventType.eventType", current_status),
            q1.or(
              [
                q1.equal(".radExamPersonnel.ordering.id",employeeid),q1.equal(".radExamPersonnel.attending.id",employeeid),q1.equal(".radExamPersonnel.authorizing.id",employeeid)
              ]
            )         
         ] 
       ));
   
  elsif (accessions.blank? == false)
   
     q1.where(q1.and(
          [
            q1.in(".accession", accessions),
            q1.or(
              [
                q1.equal(".radExamPersonnel.ordering.id",employeeid),q1.equal(".radExamPersonnel.attending.id",employeeid),q1.equal(".radExamPersonnel.authorizing.id",employeeid)
              ]
            )         
         ] 
       ));
  elsif (current_status.blank? == false)
   
      q1.where(q1.and(
                        [
                          q1.in(".currentStatus.universalEventType.eventType", current_status),
                          q1.or(
                            [
                             q1.equal(".radExamPersonnel.ordering.id",employeeid),q1.equal(".radExamPersonnel.attending.id",employeeid),q1.equal(".radExamPersonnel.authorizing.id",employeeid)
                            ]
                          )         
                       ] 
       ));
  else 
    #none
    puts "Both are BLANK  (default) !!!" + employeeid.to_s
   #q1.where(q1.equal(".radExamPersonnel.performingId",employeeid) )
   q1.where(q1.or( 
       [
          q1.equal(".radExamPersonnel.ordering.id",employeeid),q1.equal(".radExamPersonnel.attending.id",employeeid),q1.equal(".radExamPersonnel.authorizing.id",employeeid)
       ]  
     )
     )
  end
#q1.where (q1.and([q1.in(".accession", accessions), q1.in(".currentStatus.universalEventType.eventType", current_status)] ) unless (accessions.blank? &&  current_status.blank?);

   @mysdk1=  q1.list.to_a 
    
  end
end
