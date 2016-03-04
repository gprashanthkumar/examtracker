class HomeController < ApplicationController
  before_filter :general_authentication
  before_filter :get_entity_manager
  after_filter :close_entity_manager
  layout 'examtracker_layout'  
    
  def index
    search();
  end
  def radiologist
    @employee = nil;
    @employee = Employee.get_employee(session[:username])
    if (!session[:username].blank?)
      logout
    elsif  (Employee.authorizedAs(session[:username],"radiologist") == false)
      render :unauthorized
    else
     @role = nil;
     @role="Radiologist"    
    render :bucket
    end
   
   
  end
  
  def technologist
    @employee = nil;
    @employee = Employee.get_employee(session[:username])
    @role = nil;
    @role="Technologist"
    puts "<-- Inside tech --> \n"
    render :bucket
  end
  
  def scheregistrar
    @employee = nil;
    @employee = Employee.get_employee(session[:username])
    @role = nil;
    @role="Schedule Registrar"
    puts "<-- Inside trans --> \n"
    render :bucket
  end
  
  def transcript
    @employee = nil;
    @employee = Employee.get_employee(session[:username])
    @role = nil;
    @role="Transcript"
    puts "<-- Inside trans --> \n"
    render :bucket
    
  end
  
  def orders
    @employee = Employee.get_employee(session[:username])
    @role = nil;
    @role="Ordering"
    puts "<-- Inside order --> \n"
    render :bucket
  end
  
  def search
    @employee = Employee.get_employee(session[:username])
  end
  
  def sdk(roletype,accession,currentstatus)
    @exams = [];
    @employee = nil;
    @employee = Employee.get_employee(session[:username])
  
    @mysdk1 = nil;
    @roleType = roletype
    case roletype
    when "Radiologist"
      @mysdk1 = Rad_Exam.radRoleData(@employee.id,accession,currentstatus)             
    when "Technologist"
      @mysdk1 = Rad_Exam.techRoleData(@employee.id,accession,currentstatus)  
    when "Schedule Registrar"
      @mysdk1 = Rad_Exam.schedRegRoleData(@employee.id,accession,currentstatus)  
    when "Transcript"
      @mysdk1 = Rad_Exam.transRoleData(@employee.id,accession,currentstatus)  
    when "Ordering"
      @mysdk1 = Rad_Exam.orderingRoleData(@employee.id,accession,currentstatus)  
    end
    
    @exams = get_examsHash(@mysdk1);
    
    #log output data
    log_hipaa_view(@mysdk1);
   
    #puts @exams.to_json;
    json_data = {
      :page=>"1",
      :total=>"3",
      :records=>"6", 
      #:rows=> JSON.parse(@exams.to_json(:only => [ :accession,:mrn,:current_status,:code,:description,:modality,:resource_name,:graph_status,:current_status,:updated_at,:patient_name,:birthdate,:site_name,:patient_class,:patient_type,:patient_location_at_exam,:radiology_department,:ordering_provider,:scheduler,:technologist,:pacs_image_count,:appt_time,:sign_in,:check_in,:begin_exam,:end_exam]))    
      :rows=> JSON.parse(@exams.to_json)
    }    
    respond_to do |format|
      format.json { render :json => json_data }
    end
   
  end
  
  def get_examsHash(mySDK)
    exams = [];
    
    mySDK.each  do |e|
      
      siteLocation = "";
      ordering_provider = ""
      scheduler = ""
      technologist = ""
      pacs_image_count = 0;
      sched_time = "";
      appt_time = "";
      sign_in = "";
      check_in = "";
      begin_exam = "";
      end_exam = "";
      order_arrival = "";
      report_time = "";
      updated_at = "";
      rad1_name = "Rad1";
      rad2_name = "Rad2";
      first_final ="";
      last_final="";

     
      if (!e.siteSublocation.blank?)        
        siteLocation += e.siteSublocation.siteLocation.location  unless e.siteSublocation.blank?;
        siteLocation += " " + e.siteSublocation.room unless e.siteSublocation.room.blank? ;
        siteLocation += "-" + e.siteSublocation.bed unless e.siteSublocation.bed.blank?;
              
      end
    
      if (!e.radExamPersonnel.blank?) 
        ordering_provider = e.radExamPersonnel.ordering.name unless e.radExamPersonnel.ordering.blank?
        scheduler = e.radExamPersonnel.scheduler.name unless e.radExamPersonnel.scheduler.blank?
        technologist = e.radExamPersonnel.technologist.name unless e.radExamPersonnel.technologist.blank?
      end     
       
      
      pacs_image_count = e.radPacsMetadatum.imageCount unless e.radExamMetadata.blank?
      
      if (!e.radExamTime.nil?)           
        sched_time  = DateTime.parse(e.radExamTime.scheduleEvent.to_s).utc.to_s  unless e.radExamTime.scheduleEvent.blank?;
        appt_time = DateTime.parse(e.radExamTime.appointment.to_s).utc.to_s  unless e.radExamTime.appointment.blank?;
        sign_in = (DateTime.parse(e.radExamTime.signIn.to_s).utc.to_s) unless e.radExamTime.signIn.blank?;
        check_in = (DateTime.parse(e.radExamTime.checkIn.to_s).utc.to_s) unless e.radExamTime.checkIn.blank?;
        begin_exam = (DateTime.parse(e.radExamTime.beginExam.to_s).utc.to_s)  unless e.radExamTime.beginExam.blank?;      
        end_exam =   (DateTime.parse(e.radExamTime.endExam.to_s).utc.to_s)  unless (e.radExamTime.endExam.blank?)      
        order_arrival = DateTime.parse(e.radExamTime.orderArrival.to_s).utc.to_s  unless e.radExamTime.blank?;  
      end     
      
      if(!e.firstFinalReport.blank?)
        first_final = DateTime.parse(e.firstFinalReport.reportEvent.to_s).utc.to_s  unless e.firstFinalReport.blank?; 
      end
        
      if(!e.lastFinalReport.blank?)
        last_final = DateTime.parse(e.lastFinalReport.reportEvent.to_s).utc.to_s  unless e.lastFinalReport.blank?; 
      end
        
      if (!e.currentReport.blank? )
        rad1_name = e.currentReport.rad1.name unless e.currentReport.rad1.blank?
        rad2_name = e.currentReport.rad2.name unless e.currentReport.rad2.blank?
      end
        
        

      updated_at =  DateTime.parse(e.updatedAt.to_s).utc.to_s  unless e.updatedAt.blank?                    
      report_time = DateTime.parse(e.currentReport.reportEvent.to_s).utc.to_s  unless e.currentReport.blank?
    
     
      grades = { "accession" => e.accession,
        "mrn" => e.patientMrn.mrn,           
        "current_status" => e.currentStatus.universalEventType.eventType,   
        "code" => (e.procedure.code unless e.procedure.nil?) ,           
        "description" => (e.procedure.description unless e.procedure.nil?),
        "modality" => (e.resource.modality.modality unless e.resource.nil?),
        "resource_name" => (e.resource.name unless e.resource.nil?),
        "graph_status" => e.currentStatus.universalEventType.eventType,           
        "updated_at" => updated_at,
        "patient_name" => ( e.patient.name unless e.patient.nil?),
        "birthdate" => ( e.patient.birthdate.to_s unless e.patient.nil?),
        "site_name" => (e.site.site unless e.site.site.nil?),
        "patient_class" => (e.siteClass.siteClass unless e.siteClass.nil?),
        "trauma" => (e.siteClass.trauma unless e.siteClass.nil?),
        "patient_type" => (e.siteClass.patientType.patientType unless e.siteClass.nil?),
        "patient_location_at_exam" => siteLocation,
        "radiology_department" => (e.radExamDepartment.description unless e.radExamDepartment.blank? ),
        "ordering_provider" => ordering_provider,
        "scheduler" => scheduler,
        "technologist" => technologist,
        "pacs_image_count" => pacs_image_count,
        "sched_time" => sched_time.to_s,
        "appt_time" => appt_time.to_s,
        "sign_in" => sign_in.to_s,
        "check_in" => check_in.to_s,
        "begin_exam" => begin_exam.to_s,
        "end_exam" => end_exam.to_s,
        "order_arrival" => order_arrival.to_s,
        "report_time" => report_time.to_s,
        "first_final"=> first_final.to_s,
        "last_final" => last_final.to_s,
        "rad1_name"=> rad1_name,
        "rad2_name" => rad2_name

      }
      #puts grades.to_json; 
        
      #remove this line after testing
      #<start>
      grades = manipulate_status_hash(grades);
      #<end>
      
      grades = get_graph_status_hash(grades);  
  
      exams << grades ;    
    end 
    #end @mysdk1 loop
    
    return exams;
  end
    
  def get_jqgrid
    accession_ids = params[:accession]
    exam_status = params[:status]
    role = params[:role]

    
    sdk(role,accession_ids,exam_status);
  end
      
  def get_jqgridSearch_exam_data 
    #search can be performed by 2 methods union or intersection.
    #if  @Search_buckets_individually value is true then its union else default intersection.
    @exams = [];
    @Search_buckets_individually = false;
    @employee = Employee.get_employee(session[:username])  
    @myvalues = params[:allSearchCriteriaInJson];
    symbolize_keys_deep! @myvalues;
    
    if ((@myvalues[:search_individual_buckets]== "on" ) ||
          (@myvalues[:search_individual_buckets]== "1" )  || 
          (@myvalues[:search_individual_buckets]== "true" )
      )
      #set as union Join search
      @Search_buckets_individually = true
    end
    @Search_buckets_individually = true
    puts "Hello world"
    
    if (@Search_buckets_individually == true) #its UNION Join
      #perform search on individual  buckets and join the records          
      idList = [];
      if ( (@myvalues[:my_reports] == "on") || (@myvalues[:my_exams] == "on") || (@myvalues[:my_orders] == "on"))

        if (@myvalues[:my_reports] == "on")
          
          @exams1 = Rad_Exam.get_exams_search_sdk(@employee.id,@myvalues,true,false,false)
          if @exams1.length > 0            
            puts "inside :my_reports length total "  +@exams1.length.to_s ;
            @exams1.each  do |e|
              if !(idList.include? e.accession)
                idList << e.accession
              end
             
            end #each
            
          end  #length>0
       
          @exams1 = nil;    
        
          puts idList.to_s + "is idList \n"
         
        end   
        
        if (@myvalues[:my_exams] == "on")
          
          @exams1 = Rad_Exam.get_exams_search_sdk(@employee.id,@myvalues,false,true,false)
          if @exams1.length > 0            
            puts "inside :my_exams length total "  +@exams1.length.to_s ;
            @exams1.each  do |e|
              if !(idList.include? e.accession)
                idList << e.accession
              end
             
            end #each
            
          end  #length>0
       
          @exams1 = nil; 
          
          puts idList.to_s + "is idList \n"
       
        end   
        
        if (@myvalues[:my_orders] == "on")
          
          @exams1 = Rad_Exam.get_exams_search_sdk(@employee.id,@myvalues,false,false,true)
          if @exams1.length > 0            
            puts "inside :my_orders length total "  +@exams1.length.to_s ;
            @exams1.each  do |e|
              if !(idList.include? e.accession)
                idList << e.accession
              end
             
            end #each
            
          end  #length>0
       
          @exams1 = nil;     
           
          puts idList.to_s + "is idList \n"
         
        end   
       
        puts  "kumar hello world"
        puts idList.to_s + "is idList \n"
        puts  "end  hello world \n"
        
       
        @mysdk1 = Rad_Exam.get_exams_search_by_id_array(idList);

      else
        @mysdk1 = Rad_Exam.get_exams_search_sdk(@employee.id,@myvalues,false,false,false)
      end   
    
    
    else #its  intersection  join NOT UNION Join
      #@exams = Rad_Exam.get_exams_search(@employee.id,@myvalues,(@myvalues[:my_orders] == "on"),(@myvalues[:my_exams] == "on"),(@myvalues[:my_reports] == "on"))  ;    
      @mysdk1 = Rad_Exam.get_exams_search_sdk(@employee.id,@myvalues,false,false,false)
    end
  
    
    @exams = get_examsHash(@mysdk1);
    
   
    
    #log output data
    log_hipaa_view(@mysdk1);
   
    #puts @exams.to_json;
    json_data = {
      :page=>"1",
      :total=>"3",
      :records=>"6", 
      #:rows=> JSON.parse(@exams.to_json(:only => [ :accession,:mrn,:current_status,:code,:description,:modality,:resource_name,:graph_status,:current_status,:updated_at,:patient_name,:birthdate,:site_name,:patient_class,:patient_type,:patient_location_at_exam,:radiology_department,:ordering_provider,:scheduler,:technologist,:pacs_image_count,:appt_time,:sign_in,:check_in,:begin_exam,:end_exam]))    
      :rows=> JSON.parse(@exams.to_json)
    }    
    respond_to do |format|
      format.json { render :json => json_data }
    end
    
  end
  
  def get_accession
    @accession_id = params[:accession_id];
    @mysdk1 = nil;
    @exams = [];
    grades= "";
    authenticity_token = params[:authenticity_token];
    
    
    #@exams = Rad_Exam.get_accession_detail(@accession_id.to_s)   
    @mysdk1 = Rad_Exam.get_accession_detail_sdk(@accession_id.to_s)     
    #log output data
    
    
    if @mysdk1.length > 0
          @exams = get_examsHash(@mysdk1);     
    end
    
    @exams.each  do |e|
      grades = e;
    end
    
    #log output data
    log_hipaa_view(@mysdk1);
    
    
    #JSON.parse(@exams.to_json)
    respond_to do |format|
      format.json { render :json => grades.to_json }
    end
    
  end
  
 def get_graph_status_hash(exam={} )
    gstatus = ""
    gstatus = exam["graph_status"];
    exam["graph_status"] ="";
    if not( (exam["order_arrival"].nil?) || (exam["order_arrival"].blank?))         
      exam["graph_status"] += "order_time->" + exam["order_arrival"].to_s + "," 
    else
      exam["graph_status"]  += "order_time->"  + ","  
    end
      
    if not( (exam["sched_time"].nil?) || (exam["sched_time"].blank?))         
      exam["graph_status"] += "sched_time->" + exam["sched_time"].to_s + "," 
    else
      exam["graph_status"]  += "sched_time->"  + ","  
    end
      
    if not( (exam["appt_time"].nil?) || (exam["appt_time"].blank?))
      exam["graph_status"] += "appt_time->" + exam["appt_time"].to_s + "," 
    else
      exam["graph_status"] += "appt_time->" +  "," 
    end
    if not( (exam["sign_in"].nil?) || (exam["sign_in"].blank?))
      exam["graph_status"] += "sign_in->" + exam["sign_in"].to_s + ","
    else
      exam["graph_status"] += "sign_in->" +  ","
    end  
    if not( (exam["check_in"].nil?) || (exam["check_in"].blank?))
      exam["graph_status"] += "check_in->" + exam["check_in"].to_s + ","
    else
      exam["graph_status"] += "check_in->"  + ","
    end  
    if not( (exam["begin_exam"].nil?) || (exam["begin_exam"].blank?))
      exam["graph_status"] += "begin_exam->" + exam["begin_exam"].to_s + ","
    else
      exam["graph_status"] += "begin_exam->" + ","
    end  
    if not( (exam["end_exam"].nil?) || (exam["end_exam"].blank?))
      exam["graph_status"] += "end_exam->" + exam["end_exam"].to_s + ","
    else
      exam["graph_status"] += "end_exam->" +  ","
    end 
    if not( (exam["report_time"].nil?) || (exam["report_time"].blank?))
      exam["graph_status"] += "final_time->" + exam["report_time"].to_s + ","
    else
      exam["graph_status"] += "final_time->" +  ","
    end      
    exam["graph_status"] += gstatus;
      
    return exam;
  end
  
  def get_accession_report
    @accession_id = params[:accession_id];
    @mysdk1 = nil;
    @exams = [];
    grades= "";
    authenticity_token = params[:authenticity_token];
    
    
    #@exams = Rad_Exam.get_accession_detail(@accession_id.to_s)   
    @mysdk1 = Rad_Exam.get_accession_detail_sdk(@accession_id.to_s)   
    
    #log output data
    if @mysdk1.length > 0
      @mysdk1.each  do |e|
        
        if(!e.radReports.blank?)
          
          
          e.radReports.each do |y|
            
            
            #:status, :report_time,:report_impression, :report_body, :rad1_name,:rad2_name
            grades = {        
              "report_time" =>  DateTime.parse(y.reportEvent.to_s).utc.to_s,  
              "report_impression" => y.reportImpression,
              "report_body" =>y.reportBody,
              "status" => y.reportStatus.universalEventType.eventType,
              "rad1_name" => y.rad1.name,
              "rad2_name" => y.rad2.name
            };
            
            #puts grades["graph_status"]
            @exams << grades ;
          end
          
        end #!e.radReports.blank?  
        
        
      end 
      #end @mysdk1 loop
    end
    
    #log output data
    log_hipaa_view(@mysdk1);
    json_data = "";
    json_data =   JSON.parse(@exams.to_json)
    #JSON.parse(@exams.to_json)
    respond_to do |format|
      format.json { render :json => json_data.to_json }
    end
    
  end
  #convert hash to symbols
  def symbolize_keys_deep!(h)
    h.keys.each do |k|
      ks  = k.respond_to?(:to_sym) ? k.to_sym : k
      h[ks] = h.delete k # Preserve order even when k == ks
      symbolize_keys_deep! h[ks] if h[ks].kind_of? Hash
    end
  end 
  
  #checking if an api key is valid
  def api_key_check(api_key)
    if Java::HarbingerSdkData::AppAuthenticationToken.firstWith({".authToken" => api_key},@entity_manager)
      true
    else
      false
    end
  end
  
  def logout
    reset_session
    @employee = nil   
    redirect_to Java::HarbingerSdk::SSO.logoutUrl()   
  end
  
  def manipulate_status_hash(exam)
    
    if ['1037','1027'].include? exam["accession"]
      exam["graph_status"] = "cancelled"
      exam["current_status"] = "cancelled"       
    end
    if '1027' == exam["accession"]
      exam["graph_status"] = "cancelled"
      exam["current_status"] = "cancelled"    
      exam["report_time"] = "";
    end
        
    if '1017' == exam["accession"]
      exam["graph_status"] = "order"
      exam["current_status"] = "order"    
    end
    if '1015' == exam["accession"]
      exam["graph_status"] = "arrived"
      exam["current_status"] = "arrived"    
    end
    
    return exam;
  end  
  
  
  def exam
    
  end
end




