class Rad_Exam < ActiveRecord::Base
  self.table_name = "public.rad_exams"
 
  
  
  def self.get_exams_search_sdk(employeeid,params,myreports = false,myexams = false,myorders = false,total=false,paginate=true,page=1,rows=10,sorder="asc")    
     
    
    @mysdk1 = " ";  
    @mysdkTotal= 0;
    @offset = 0
    qmyreports = nil;
    qmyexams =nil;
    qmyorders = nil;   
    
    querySDK = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager) 
    
    if( myreports == true) 
      qmyreports =   
        querySDK.or([
          querySDK.equal(".currentReport.rad1.id",employeeid),\
            querySDK.equal(".currentReport.rad2.id",employeeid),\
            querySDK.equal(".currentReport.rad3.id",employeeid),\
            querySDK.equal(".currentReport.rad4.id",employeeid)
        ].delete_if {myreports != true}
      );
    else
      qmyreports =   querySDK.equal(".id",".id");
    end
    
    if (myexams == true)
        
      qmyexams =   
        querySDK.or([
          querySDK.equal(".radExamPersonnel.performing.id",employeeid),\
            querySDK.equal(".radExamPersonnel.technologist.id",employeeid),\
            querySDK.equal(".radExamPersonnel.scheduler.id",employeeid)
        ].delete_if {myexams != true}
      );
    else
      qmyexams = querySDK.equal(".id",".id");
    end
             
     
    if (myorders == true)       
      
      qmyorders =   
        querySDK.or([
          querySDK.equal(".radExamPersonnel.attending.id",employeeid),\
            querySDK.equal(".radExamPersonnel.ordering.id",employeeid),\
            querySDK.equal(".radExamPersonnel.authorizing.id",employeeid)
        ].delete_if {myorders != true}
      );
    else
      qmyorders = querySDK.equal(".id",".id");
    end 
        
    #visit
    qmyvisit =  querySDK.equal(".id",".id");     
    if ((params[:visit] != "") && !(params[:visit].nil?) && !(params[:visit].blank?)) 
      qmyvisit = querySDK.ilike(".visit.visitNumber", "%#{params[:visit]}%");
    end
     
    #:order_id
    qmyorder =  querySDK.equal(".id",".id");     
    if ((params[:order_id] != "") && !(params[:order_id].nil?) && !(params[:order_id].blank?)) 
      qmyorder = querySDK.ilike(".order.orderNumber", "%#{params[:order_id]}%");
    end
    
    #:accession
    qmyaccession =  querySDK.equal(".id",".id");
    if ((params[:accession] != "") && !(params[:accession].nil?) && !(params[:accession].blank?))            
      qmyaccession = querySDK.ilike(".accession", "%#{params[:accession]}%");
    end 
    
    #:patient_type
    qmypatientType =  querySDK.equal(".id",".id");
    if ((params[:patient_type] != "") && !(params[:patient_type].nil?) && !(params[:patient_type].blank?))            
      qmypatientType = querySDK.ilike(".siteClass.patientType.patientType", "#{params[:patient_type]}");
    end 
    
    #:mrn 
    qmymrn =  querySDK.equal(".id",".id");
    if ((params[:mrn] != "") && !(params[:mrn].nil?) && !(params[:mrn].blank?))            
      qmymrn = querySDK.ilike(".patientMrn.mrn", "%#{params[:mrn]}");
    end 
    
    #:patient_name
    qmyname =  querySDK.equal(".id",".id");
    if ((params[:patient_name] != "") && !(params[:patient_name].nil?) && !(params[:patient_name].blank?))          
      qmyname  = querySDK.ilike(".patientMrn.patient.name", "%#{params[:patient_name]}%");
    end   
    #:modality
    qmymodality =  querySDK.equal(".id",".id");
    if ((params[:modality] != "") && !(params[:modality].nil?) && !(params[:modality].blank?))          
      qmymodality =  querySDK.ilike(".resource.modality.modality", "%#{params[:modality]}%");
    end
    
    #:code 
    qmycode  =  querySDK.equal(".id",".id");
    if ((params[:code] != "") && !(params[:code].nil?) && !(params[:code].blank?))          
      qmycode =  querySDK.ilike(".procedure.code", "%#{params[:code]}%");
    end
    
    #:resource_name
    qmyresourceName  =  querySDK.equal(".id",".id");
    if ((params[:resource_name] != "") && !(params[:resource_name].nil?) && !(params[:resource_name].blank?))          
      qmyresourceName  =  querySDK.ilike(".resource.name", "%#{params[:resource_name]}%");
    end
    
      
    #:rad_exam_dept
    qmyradExamDept =  querySDK.equal(".id",".id");
    if ((params[:rad_exam_dept] != "") && !(params[:rad_exam_dept].nil?) && !(params[:rad_exam_dept].blank?))   
      qmyradExamDept  =  querySDK.ilike(".radExamDepartment.description", "%#{params[:rad_exam_dept]}%");
    end
     
    # :current_status
    qmycurrentStatus =  querySDK.equal(".id",".id");
    if ((params[:current_status] != "") && !(params[:current_status].nil?) && !(params[:current_status].blank?))          
      qmycurrentStatus =  querySDK.ilike(".currentStatus.universalEventType.eventType", "%#{params[:current_status]}%");
    end
  
    qmypatientExamLocation =  querySDK.equal(".id",".id");
    if ((params[:patient_location_at_exam] != "") && !(params[:patient_location_at_exam].nil?) && !(params[:patient_location_at_exam].blank?))          
      qmypatientExamLocation =  querySDK.ilike(".siteSublocation.siteLocation.location", "%#{params[:patient_location_at_exam]}%");
    end
     
    qmysiteName =  querySDK.equal(".id",".id");
    if ((params[:site_name] != "") && !(params[:site_name].nil?) && !(params[:site_name].blank?))
      qmysiteName =  querySDK.ilike(".site.site", "%#{params[:site_name]}%");
    end
     
    #Build final query to execute
    querySDK.where(querySDK.and(
        [qmyreports,qmyexams,qmyorders,qmyvisit,\
            qmyorder,qmyaccession,qmypatientType,\
            qmymrn,qmyname,qmymodality,qmycode,qmyresourceName,\
            qmyradExamDept,qmycurrentStatus,qmypatientExamLocation, \
            qmysiteName
           
        ]
      ));
    
    #puts querySDK.toSQL;
    @mysdkTotal = querySDK.list.count ;
   
    if (total)    
      return @mysdkTotal.to_s
    else 
      if @mysdkTotal > 0 
        if (paginate)
          @offset = (page - 1)*rows
          if @offset < 0 
            @offset = 0
          end
          @mysdk1=  querySDK.offset(@offset).limit(rows).list.to_a 
          return @mysdk1       
        else
          @mysdk1=  querySDK.list.to_a 
        end       
      else
        @mysdk1=  querySDK.list.to_a 
      end     
      return @mysdk1
    end
    
    
  
  end
  
  #Definition:  This is the definition called to return list of  exam records matching passed eccessionid list idList
  def self.get_exams_search_by_id_array(idList,total=false,page=1,rows=10,sord="asc")
    @mysdkTotal = 0;
    @offset =0;
    querySDK = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager) 
    if (idList.length > 0)
      querySDK.where(
        querySDK.in(".accession", idList)
      );
      @mysdkTotal = querySDK.list.count 
    else
      querySDK.where(
        querySDK.equal(".id", -1)
      );
    end
   
  
   
    if (total)   
   
      return @mysdkTotal
    else     
       if @mysdkTotal > 0 
        @offset = (page - 1)*rows;
        if @offset < 0 
          @offset = 0
        end
        @mysdk1=  querySDK.offset(@offset).limit(rows).list.to_a 
      else
        @mysdk1=  querySDK.list.to_a 
      end       
      return @mysdk1
    end
    
  end
  
  #Definition: This is main query from ra_exams details of for passed accessionid as accession of the exam
 
  def self.get_accession_detail_sdk(accessionid)
  
    querySDK = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager) 
    if (!accessionid.blank?)
      querySDK.where(
        querySDK.equal(".accession", accessionid)      
      );
     
    else
      querySDK.where(
        querySDK.equal(".id", -1)
      );
    end
    return querySDK.list.to_a 
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
    querySDK = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager)         
 
    if ( (accessions.blank? == false) && (current_status.blank? == false) ) 
   
        
      querySDK.where(querySDK.and(
          [
            querySDK.in(".accession", accessions), 
            querySDK.in(".currentStatus.universalEventType.eventType", current_status),
            querySDK.or(
              [
                querySDK.equal(".currentReport.rad1.id",employeeid),
                querySDK.equal(".currentReport.rad2.id",employeeid),
                querySDK.equal(".currentReport.rad3.id",employeeid),
                querySDK.equal(".currentReport.rad4.id",employeeid),
                querySDK.equal(".radExamPersonnel.performingId",employeeid)
              ]
            )         
          ] 
        ));
   
    elsif (accessions.blank? == false)
   
      querySDK.where(querySDK.and(
          [
            querySDK.in(".accession", accessions),
            querySDK.or(
              [
                querySDK.equal(".currentReport.rad1.id",employeeid),
                querySDK.equal(".currentReport.rad2.id",employeeid),
                querySDK.equal(".currentReport.rad3.id",employeeid),
                querySDK.equal(".currentReport.rad4.id",employeeid),
                querySDK.equal(".radExamPersonnel.performingId",employeeid)
              ]
            )         
          ] 
        ));
    elsif (current_status.blank? == false)
   
      querySDK.where(querySDK.and(
          [
            querySDK.in(".currentStatus.universalEventType.eventType", current_status),
            querySDK.or(
              [
                querySDK.equal(".currentReport.rad1.id",employeeid),querySDK.equal(".currentReport.rad2.id",employeeid),querySDK.equal(".currentReport.rad3.id",employeeid),querySDK.equal(".currentReport.rad4.id",employeeid),querySDK.equal(".radExamPersonnel.performingId",employeeid)
              ]
            )         
          ] 
        ));
    else 
      querySDK.where(querySDK.or ( [
            querySDK.equal(".currentReport.rad1.id",employeeid),querySDK.equal(".currentReport.rad2.id",employeeid),querySDK.equal(".currentReport.rad3.id",employeeid),querySDK.equal(".currentReport.rad4.id",employeeid)]  )
      )
    end
    @mysdkTotal = querySDK.list.count 
    if (total)    
      return @mysdkTotal.to_s
    else 
      if @mysdkTotal > 0 
        @offset = (page - 1)*rows
        if @offset < 0 
          @offset = 0
        end
        @mysdk1=  querySDK.offset(@offset).limit(rows).list.to_a 
      else
        @mysdk1=  querySDK.list.to_a 
      end     
      return @mysdk1
    end
    
  end
  
  def self.techRoleData(employeeid,accessions,current_status,page,rows,sord,total=false)
    @mysdk1 = " ";  
    querySDK = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager)  
   
    if ( (accessions.blank? == false) && (current_status.blank? == false) ) 
   
        
      querySDK.where(querySDK.and(
          [
            querySDK.in(".accession", accessions), querySDK.in(".currentStatus.universalEventType.eventType", current_status),
            querySDK.or(
              [
                querySDK.equal(".radExamPersonnel.assistingTech1.id",employeeid),querySDK.equal(".radExamPersonnel.assistingTech2.id",employeeid),querySDK.equal(".radExamPersonnel.assistingTech3.id",employeeid),querySDK.equal(".radExamPersonnel.technologist.id",employeeid)
              ]
            )         
          ] 
        ));
   
    elsif (accessions.blank? == false)
   
      querySDK.where(querySDK.and(
          [
            querySDK.in(".accession", accessions),
            querySDK.or(
              [
                querySDK.equal(".radExamPersonnel.assistingTech1.id",employeeid),querySDK.equal(".radExamPersonnel.assistingTech2.id",employeeid),querySDK.equal(".radExamPersonnel.assistingTech3.id",employeeid),querySDK.equal(".radExamPersonnel.technologist.id",employeeid)
              ]
            )         
          ] 
        ));
    elsif (current_status.blank? == false)
   
      querySDK.where(querySDK.and(
          [
            querySDK.in(".currentStatus.universalEventType.eventType", current_status),
            querySDK.or(
              [
                querySDK.equal(".radExamPersonnel.assistingTech1.id",employeeid),querySDK.equal(".radExamPersonnel.assistingTech2.id",employeeid),querySDK.equal(".radExamPersonnel.assistingTech3.id",employeeid),querySDK.equal(".radExamPersonnel.technologist.id",employeeid)
              ]
            )         
          ] 
        ));
    else 
   
      querySDK.where(querySDK.or(
          [
            querySDK.equal(".radExamPersonnel.assistingTech1.id",employeeid),querySDK.equal(".radExamPersonnel.assistingTech2.id",employeeid),querySDK.equal(".radExamPersonnel.assistingTech3.id",employeeid),querySDK.equal(".radExamPersonnel.technologist.id",employeeid)            
          ] 
        )
      )
    end


    if (total)    
      return querySDK.list.count.to_s
    else 
      @offset = (page - 1)*rows
      if @offset < 0 
        @offset = 0
      end
      @mysdk1=  querySDK.offset(@offset).limit(rows).list.to_a 
      return @mysdk1
    end
    
  end
  
  def self.schedRegRoleData(employeeid,accessions,current_status,page,rows,sord,total=false)
    @mysdk1 = " ";  
    querySDK = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager)  

    if ( (accessions.blank? == false) && (current_status.blank? == false) ) 
   
        
      querySDK.where(querySDK.and(
          [
            querySDK.in(".accession", accessions), querySDK.in(".currentStatus.universalEventType.eventType", current_status),
            querySDK.or(
              [
                querySDK.equal(".radExamPersonnel.scheduler.id",employeeid),querySDK.equal(".radExamPersonnel.checkin.id",employeeid),querySDK.equal(".radExamPersonnel.beginExam.id",employeeid)
                
              ]
            )         
          ] 
        ));
   
    elsif (accessions.blank? == false)
   
      querySDK.where(querySDK.and(
          [
            querySDK.in(".accession", accessions),
            querySDK.or(
              [
                querySDK.equal(".currentReport.rad1.id",employeeid),querySDK.equal(".currentReport.rad2.id",employeeid),querySDK.equal(".currentReport.rad3.id",employeeid),querySDK.equal(".currentReport.rad4.id",employeeid),querySDK.equal(".radExamPersonnel.performingId",employeeid)
              ]
            )         
          ] 
        ));
    elsif (current_status.blank? == false)
   
      querySDK.where(querySDK.and(
          [
            querySDK.in(".currentStatus.universalEventType.eventType", current_status),
            querySDK.or(
              [
                querySDK.equal(".currentReport.rad1.id",employeeid),querySDK.equal(".currentReport.rad2.id",employeeid),querySDK.equal(".currentReport.rad3.id",employeeid),querySDK.equal(".currentReport.rad4.id",employeeid),querySDK.equal(".radExamPersonnel.performingId",employeeid)
              ]
            )         
          ] 
        ));
    else 
      querySDK.where(querySDK.or ( [
            querySDK.equal(".currentReport.rad1.id",employeeid),querySDK.equal(".currentReport.rad2.id",employeeid),querySDK.equal(".currentReport.rad3.id",employeeid),querySDK.equal(".currentReport.rad4.id",employeeid)]  )
      )
    end

    if (total)    
      return querySDK.list.count.to_s
    else 
      @offset = (page - 1)*rows
      if @offset < 0 
        @offset = 0
      end
      @mysdk1=  querySDK.offset(@offset).limit(rows).list.to_a 
      return @mysdk1
    end
    
  end
  
  def self.transRoleData(employeeid,accessions,current_status,page,rows,sord,total=false)
    @mysdk1 = " ";  
    querySDK = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager)  

    if ( (accessions.blank? == false) && (current_status.blank? == false) ) 
   
       
      querySDK.where(querySDK.and(
          [
            querySDK.in(".accession", accessions), querySDK.in(".currentStatus.universalEventType.eventType", current_status),
            querySDK.equal(".currentReport.transcriptionist.id",employeeid)         
          ] 
        ));
   
    elsif (accessions.blank? == false)
   
      querySDK.where(querySDK.and(
          [
            querySDK.in(".accession", accessions),
            querySDK.equal(".currentReport.transcriptionist.id",employeeid)                             
          ] 
        )
      );
    elsif (current_status.blank? == false)
   
      querySDK.where(querySDK.and(
          [
            querySDK.in(".currentStatus.universalEventType.eventType", current_status),
            querySDK.equal(".currentReport.transcriptionist.id",employeeid)                
          ] 
        ));
    else 
      querySDK.where(
        querySDK.equal(".currentReport.transcriptionist.id",employeeid)         
      )
    end

    if (total)    
      return querySDK.list.count.to_s
    else 
      @offset = (page - 1)*rows
      if @offset < 0 
        @offset = 0
      end
      @mysdk1=  querySDK.offset(@offset).limit(rows).list.to_a 
      return @mysdk1
    end
    
  end
  
  def self.orderingRoleData(employeeid,accessions,current_status,page,rows,sord,total=false)
  
    @mysdk1 = " ";  
    @mysdkTotal =0;
    querySDK = Java::HarbingerSdkData::RadExam.createQuery(@entity_manager)  
    if ( (accessions.blank? == false) && (current_status.blank? == false) ) 
      querySDK.where(querySDK.and(
          [
            querySDK.in(".accession", accessions), querySDK.in(".currentStatus.universalEventType.eventType", current_status),
            querySDK.or(
              [
                querySDK.equal(".radExamPersonnel.ordering.id",employeeid),querySDK.equal(".radExamPersonnel.attending.id",employeeid),querySDK.equal(".radExamPersonnel.authorizing.id",employeeid)
              ]
            )         
          ] 
        ));
   
    elsif (accessions.blank? == false)
   
      querySDK.where(querySDK.and(
          [
            querySDK.in(".accession", accessions),
            querySDK.or(
              [
                querySDK.equal(".radExamPersonnel.ordering.id",employeeid),querySDK.equal(".radExamPersonnel.attending.id",employeeid),querySDK.equal(".radExamPersonnel.authorizing.id",employeeid)
              ]
            )         
          ] 
        ));
    elsif (current_status.blank? == false)
   
      querySDK.where(querySDK.and(
          [
            querySDK.in(".currentStatus.universalEventType.eventType", current_status),
            querySDK.or(
              [
                querySDK.equal(".radExamPersonnel.ordering.id",employeeid),querySDK.equal(".radExamPersonnel.attending.id",employeeid),querySDK.equal(".radExamPersonnel.authorizing.id",employeeid)
              ]
            )         
          ] 
        ));
    else 
      querySDK.where(querySDK.or( 
          [
            querySDK.equal(".radExamPersonnel.ordering.id",employeeid),querySDK.equal(".radExamPersonnel.attending.id",employeeid),querySDK.equal(".radExamPersonnel.authorizing.id",employeeid)
          ]  
        )
      )
    end
    @mysdkTotal = querySDK.list.count
    if (total)    
      return @mysdkTotal.to_s
    else 
      @offset = (page - 1)*rows
      if @offset < 0 
        @offset = 0
      end
      @mysdk1=  querySDK.offset(@offset).limit(rows).list.to_a 
      return @mysdk1
    end
     
      
    
 
    
  end
end
