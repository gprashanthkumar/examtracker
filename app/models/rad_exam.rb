class Rad_Exam < ActiveRecord::Base
  self.table_name = "public.rad_exams"
 
  
  
   def self.get_exams_search_sdk(employeeid,params,myreports = false,myexams = false,myorders = false)    
     
    puts "inside get_exams_search_sdk "
     #exams_search = self.join_Main.Rad_Tech_Sched_Trans_Other; 
    @mysdk1 = " ";  
    
      q1 = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager) 
      #q1.join(".patient")
    qmyreports = nil;
    qmyexams =nil;
    qmyorders = nil;   
   
     
     
      #exams_search = exams_search.where("( (rr.rad1_id = ?) or (rr.rad2_id = ?) or  (rr.rad3_id = ?) or (rr.rad4_id = ?)) ",employeeid,employeeid,employeeid,employeeid).all;
      if( myreports == true) 
         qmyreports =   
           q1.or([
              q1.equal(".currentReport.rad1.id",employeeid),\
              q1.equal(".currentReport.rad2.id",employeeid),\
              q1.equal(".currentReport.rad3.id",employeeid),\
              q1.equal(".currentReport.rad4.id",employeeid)
                 ].delete_if {myreports != true}
               );
      else
       qmyreports =   q1.equal(".id",".id");
      end
    
    
     puts "<--- qmyreports" +  qmyreports.to_s  + "--> \n"
     
      #exams_search = exams_search.where("( (repp.performing_id = ?) or (repp.technologist_id = ?) or  (repp.scheduler_id = ?) ) ",employeeid,employeeid,employeeid).all;
      if (myexams == true)
        
        qmyexams =   
           q1.or([
                  q1.equal(".radExamPersonnel.performing.id",employeeid),\
                    q1.equal(".radExamPersonnel.technologist.id",employeeid),\
                    q1.equal(".radExamPersonnel.scheduler.id",employeeid)
                 ].delete_if {myexams != true}
               );
      else
         qmyexams = q1.equal(".id",".id");
      end
             
       puts "<--- qmyexams " +  qmyexams.to_s  + "--> \n"       
      
     
        if (myorders == true)       
      #exams_search = exams_search.where("( (repp.attending_id = ?) or (repp.ordering_id = ?) or  (repp.authorizing_id = ?) ) ",employeeid,employeeid,employeeid).all;       
        qmyorders =   
           q1.or([
              q1.equal(".radExamPersonnel.attending.id",employeeid),\
                q1.equal(".radExamPersonnel.ordering.id",employeeid),\
                q1.equal(".radExamPersonnel.authorizing.id",employeeid)
                 ].delete_if {myorders != true}
               );
        else
           qmyorders = q1.equal(".id",".id");
        end 
        
     #visit
     qmyvisit =  q1.equal(".id",".id");
     
     if ((params[:visit] != "") && !(params[:visit].nil?) && !(params[:visit].blank?)) 
      #exams_search = exams_search.joins("Left JOIN visits v on v.id = rad_exams.visit_id")
      #exams_search = exams_search.where(" (v.visit_number ilike ?)  " , "%#{params[:visit]}%" ).all ;      
      qmyvisit = q1.ilike(".visit.visitNumber", "%#{params[:visit]}%");
    end
     
      #order_id
     qmyorder =  q1.equal(".id",".id");
     
     if ((params[:order_id] != "") && !(params[:order_id].nil?) && !(params[:order_id].blank?)) 
      #exams_search = exams_search.joins("Left JOIN orders o on o.id = rad_exams.order_id")
      #exams_search = exams_search.where(" (o.order_number ilike ?)  " , "%#{params[:order_id]}%" ).all ;
        qmyorder = q1.ilike(".order.orderNumber", "%#{params[:order_id]}%");
    end
    
     #:accession
     qmyaccession =  q1.equal(".id",".id");
     if ((params[:accession] != "") && !(params[:accession].nil?) && !(params[:accession].blank?))            
       qmyaccession = q1.ilike(".accession", "%#{params[:accession]}%");
    end 
    
    #:patient_type
    qmypatientType =  q1.equal(".id",".id");
     if ((params[:patient_type] != "") && !(params[:patient_type].nil?) && !(params[:patient_type].blank?))            
      #exams_search = exams_search.where("pt.id = ?", params[:patient_type] ).all ;
      qmypatientType = q1.ilike(".siteClass.patientType.patientType", "#{params[:patient_type]}");
    end 
    
    #:mrn 
    qmymrn =  q1.equal(".id",".id");
    if ((params[:mrn] != "") && !(params[:mrn].nil?) && !(params[:mrn].blank?))            
      #exams_search = exams_search.where("pmrn.mrn ilike ?", "%#{params[:mrn]}%" ).all ;
      qmymrn = q1.ilike(".patientMrn.mrn", "%#{params[:mrn]}");
    end 
    
    #:patient_name
      qmyname =  q1.equal(".id",".id");
    if ((params[:patient_name] != "") && !(params[:patient_name].nil?) && !(params[:patient_name].blank?))          
      qmyname  = q1.ilike(".patientMrn.patient.name", "%#{params[:patient_name]}%");
    end   
     #:modality
     qmymodality =  q1.equal(".id",".id");
      if ((params[:modality] != "") && !(params[:modality].nil?) && !(params[:modality].blank?))          
      qmymodality =  q1.ilike(".resource.modality.modality", "%#{params[:modality]}%");
    end
    
     #:code 
      qmycode  =  q1.equal(".id",".id");
     if ((params[:code] != "") && !(params[:code].nil?) && !(params[:code].blank?))          
      
      #exams_search = exams_search.where("  concat(proc.code, proc.description)  ilike ?", "%#{params[:code]}%" ).all ;
      qmycode =  q1.ilike(".procedure.code", "%#{params[:code]}%");
      
    end
    
     #:resource_name
      qmyresourceName  =  q1.equal(".id",".id");
     if ((params[:resource_name] != "") && !(params[:resource_name].nil?) && !(params[:resource_name].blank?))          
      
      #exams_search = exams_search.where("  res.name  ilike ?", "%#{params[:resource_name]}%" ).all ;
      qmyresourceName  =  q1.ilike(".resource.name", "%#{params[:resource_name]}%");
    end
    
      
     #:rad_exam_dept
     qmyradExamDept =  q1.equal(".id",".id");
     if ((params[:rad_exam_dept] != "") && !(params[:rad_exam_dept].nil?) && !(params[:rad_exam_dept].blank?))   
       
      qmyradExamDept  =  q1.ilike(".radExamDepartment.description", "%#{params[:rad_exam_dept]}%");
      
     end
     
     # :current_status
     qmycurrentStatus =  q1.equal(".id",".id");
      #qmycurrentStatus = nil;
     if ((params[:current_status] != "") && !(params[:current_status].nil?) && !(params[:current_status].blank?))          
      qmycurrentStatus =  q1.ilike(".currentStatus.universalEventType.eventType", "%#{params[:current_status]}%");
     end
     qmypatientExamLocation =  q1.equal(".id",".id");
     if ((params[:patient_location_at_exam] != "") && !(params[:patient_location_at_exam].nil?) && !(params[:patient_location_at_exam].blank?))          
       qmypatientExamLocation =  q1.ilike(".siteSublocation.siteLocation.location", "%#{params[:patient_location_at_exam]}%");
     end
     
     qmysiteName =  q1.equal(".id",".id");
     if ((params[:site_name] != "") && !(params[:site_name].nil?) && !(params[:site_name].blank?))
         qmysiteName =  q1.ilike(".site.site", "%#{params[:site_name]}%");
     end
         
      
     
   
        q1.where(q1.and(
          [qmyreports,qmyexams,qmyorders,qmyvisit,\
           qmyorder,qmyaccession,qmypatientType,\
           qmymrn,qmyname,qmymodality,qmycode,qmyresourceName,\
           qmyradExamDept,qmycurrentStatus,qmypatientExamLocation, \
           qmysiteName
           
          ]
         ));
    
    puts q1.toSQL;
    return q1.list.to_a ;

  
  end
  
  #Definition:  This is the definition called to return list of  exam records matching passed eccessionid list idList
  def self.get_exams_search_by_id_array(idList)
    #exams_search = self.join_Main.Rad_Tech_Sched_Trans_Other;  
    #exams_search = exams_search.where("rad_exams.id in (?)", idList ).order("id desc").all ;
    #return exams_search;   
    puts "Inside idList"
     q1 = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager) 
     if (idList.length > 0)
       q1.where(
      q1.in(".accession", idList)
     );
     
     else
        q1.where(
      q1.equal(".id", -1)
      );
     end
     return q1.list.to_a 
    
  end
  
  #Definition: This is main query from ra_exams details of for passed accessionid as accession of the exam
 
   def self.get_accession_detail_sdk(accessionid)
  
    q1 = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager) 
     if (!accessionid.blank?)
       q1.where(
          q1.equal(".accession", accessionid)      
     );
     
     else
        q1.where(
      q1.equal(".id", -1)
      );
     end
     return q1.list.to_a 
  end
  
  
   #Definitions: This is the definition to return resultset of reports records for passed accessionid as accession of the reports
  def self.get_accession_reports_sdk(accessionid)
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
