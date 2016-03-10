class Rad_Exam < ActiveRecord::Base
  self.table_name = "public.rad_exams"
 
  
  
  def self.get_exams_search_sdk(employeeid,params,myreports = false,myexams = false,myorders = false,total=false,paginate=true,page=1,rows=10,sorder="asc")    
     
    
    @mysdk1 = " ";  
    @mysdkTotal= 0;
    qmyreports = nil;
    qmyexams =nil;
    qmyorders = nil;   
    
    q1 = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager) 
    
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
             
     
    if (myorders == true)       
      
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
      qmyvisit = q1.ilike(".visit.visitNumber", "%#{params[:visit]}%");
    end
     
    #:order_id
    qmyorder =  q1.equal(".id",".id");     
    if ((params[:order_id] != "") && !(params[:order_id].nil?) && !(params[:order_id].blank?)) 
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
      qmypatientType = q1.ilike(".siteClass.patientType.patientType", "#{params[:patient_type]}");
    end 
    
    #:mrn 
    qmymrn =  q1.equal(".id",".id");
    if ((params[:mrn] != "") && !(params[:mrn].nil?) && !(params[:mrn].blank?))            
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
      qmycode =  q1.ilike(".procedure.code", "%#{params[:code]}%");
    end
    
    #:resource_name
    qmyresourceName  =  q1.equal(".id",".id");
    if ((params[:resource_name] != "") && !(params[:resource_name].nil?) && !(params[:resource_name].blank?))          
      qmyresourceName  =  q1.ilike(".resource.name", "%#{params[:resource_name]}%");
    end
    
      
    #:rad_exam_dept
    qmyradExamDept =  q1.equal(".id",".id");
    if ((params[:rad_exam_dept] != "") && !(params[:rad_exam_dept].nil?) && !(params[:rad_exam_dept].blank?))   
      qmyradExamDept  =  q1.ilike(".radExamDepartment.description", "%#{params[:rad_exam_dept]}%");
    end
     
    # :current_status
    qmycurrentStatus =  q1.equal(".id",".id");
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
     
    #Build final query to execute
    q1.where(q1.and(
        [qmyreports,qmyexams,qmyorders,qmyvisit,\
            qmyorder,qmyaccession,qmypatientType,\
            qmymrn,qmyname,qmymodality,qmycode,qmyresourceName,\
            qmyradExamDept,qmycurrentStatus,qmypatientExamLocation, \
            qmysiteName
           
        ]
      ));
    
    #puts q1.toSQL;
    @mysdkTotal = q1.list.count ;
   
    if (total)    
      return @mysdkTotal.to_s
    else 
      if @mysdkTotal > 0 
         if (paginate)
            @mysdk1=  q1.limit(rows).list.to_a 
         else
            @mysdk1=  q1.list.to_a 
         end       
      else
        @mysdk1=  q1.list.to_a 
      end     
      return @mysdk1
    end
    
    
  
  end
  
  #Definition:  This is the definition called to return list of  exam records matching passed eccessionid list idList
  def self.get_exams_search_by_id_array(idList,total = false,page=1,rows=10,sord="asc")
    @mysdkTotal = 0;
    
    q1 = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager) 
    if (idList.length > 0)
      q1.where(
        q1.in(".accession", idList)
      );
       @mysdkTotal = q1.list.count 
    else
      q1.where(
        q1.equal(".id", -1)
      );
    end
   
   
    if (total)    
      return @mysdkTotal.to_s
    else 
      if @mysdkTotal > 0 
        @mysdk1=  q1.limit(rows).list.to_a 
      else
        @mysdk1=  q1.list.to_a 
      end     
      return @mysdk1
    end
    
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
  
  #Definitions: This is the  utility definition 
  #(this can be moved out of this module to any other, as long as its accessible from this module).
  def self.string_array_to_string(arraystring)
    arraystring.gsub! "[","";
    arraystring.gsub! "]","";
    arraystring.gsub!  "\", \"", "', '";
    arraystring.gsub!  "\"", "'";
    return arraystring;
  end 

  
  def self.radRoleData(employeeid,accessions,current_status,page,rows,sord,total = false)
    @mysdk1 = " ";  
    @mysdkTotal = 0;
    q1 = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager)         
 
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
      q1.where(q1.or ( [
            q1.equal(".currentReport.rad1.id",employeeid),q1.equal(".currentReport.rad2.id",employeeid),q1.equal(".currentReport.rad3.id",employeeid),q1.equal(".currentReport.rad4.id",employeeid)]  )
      )
    end
    @mysdkTotal = q1.list.count 
    if (total)    
      return @mysdkTotal.to_s
    else 
      if @mysdkTotal > 0 
        @mysdk1=  q1.limit(rows).list.to_a 
      else
        @mysdk1=  q1.list.to_a 
      end     
      return @mysdk1
    end
    
  end
  
  def self.techRoleData(employeeid,accessions,current_status,page,rows,sord,total=false)
    @mysdk1 = " ";  
    q1 = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager)  
   
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
   
      q1.where(q1.or(
          [
            q1.equal(".radExamPersonnel.assistingTech1.id",employeeid),q1.equal(".radExamPersonnel.assistingTech2.id",employeeid),q1.equal(".radExamPersonnel.assistingTech3.id",employeeid),q1.equal(".radExamPersonnel.technologist.id",employeeid)            
          ] 
        )
      )
    end


    if (total)    
      return q1.list.count.to_s
    else 
      @mysdk1=  q1.limit(rows).list.to_a 
      return @mysdk1
    end
    
  end
  
  def self.schedRegRoleData(employeeid,accessions,current_status,page,rows,sord,total=false)
    @mysdk1 = " ";  
    q1 = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager)  

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
      q1.where(q1.or ( [
            q1.equal(".currentReport.rad1.id",employeeid),q1.equal(".currentReport.rad2.id",employeeid),q1.equal(".currentReport.rad3.id",employeeid),q1.equal(".currentReport.rad4.id",employeeid)]  )
      )
    end

    if (total)    
      return q1.list.count.to_s
    else 
      @mysdk1=  q1.limit(rows).list.to_a 
      return @mysdk1
    end
    
  end
  
  def self.transRoleData(employeeid,accessions,current_status,page,rows,sord,total=false)
    @mysdk1 = " ";  
    q1 = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager)  

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
      q1.where(
        q1.equal(".currentReport.transcriptionist.id",employeeid)         
      )
    end

    if (total)    
      return q1.list.count.to_s
    else 
      @mysdk1=  q1.limit(rows).list.to_a 
      return @mysdk1
    end
    
  end
  
  def self.orderingRoleData(employeeid,accessions,current_status,page,rows,sord,total=false)
  
    @mysdk1 = " ";  
    @mysdkTotal =0;
    q1 = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager)  
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
      q1.where(q1.or( 
          [
            q1.equal(".radExamPersonnel.ordering.id",employeeid),q1.equal(".radExamPersonnel.attending.id",employeeid),q1.equal(".radExamPersonnel.authorizing.id",employeeid)
          ]  
        )
      )
    end
    @mysdkTotal = q1.list.count
    if (total)    
      return @mysdkTotal.to_s
    else 
      @mysdk1=  q1.limit(rows).list.to_a 
      return @mysdk1
    end
     
      
    
 
    
  end
end
