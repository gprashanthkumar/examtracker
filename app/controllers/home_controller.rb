class HomeController < ApplicationController
  before_filter :general_authentication
  before_filter :get_entity_manager
  after_filter :close_entity_manager
  layout 'examtracker_layout'  
    
  def radiologist
    @employee = Employee.get_employee(session[:username])
  end
  
  def technologist
    @employee = Employee.get_employee(session[:username])
  end
  
  def scheregistrar
    @employee = Employee.get_employee(session[:username])
  end
  
  def transcript
    @employee = Employee.get_employee(session[:username])
  end
  
  def others
    @employee = Employee.get_employee(session[:username])
  end
  
  def search
    @employee = Employee.get_employee(session[:username])
  end
    
  def get_jqgridRad
    accession_ids = params[:accession]
    exam_status = params[:status]
	
    get_jqgrid_common("rad",accession_ids,exam_status);  
  end
  
  def get_jqgridTech
    accession_ids = params[:accession]
    exam_status = params[:status]
    get_jqgrid_common("tech",accession_ids,exam_status);    
  end
  
  def get_jqgridScheReg
    accession_ids = params[:accession]
    exam_status = params[:status]
    get_jqgrid_common("schedreg",accession_ids,exam_status);    
  end
  
  def get_jqgridTranscript
    accession_ids = params[:accession]
    exam_status = params[:status]
    get_jqgrid_common("trans",accession_ids,exam_status);    
  end
    
  def get_jqgridOthers
    accession_ids = params[:accession]
    exam_status = params[:status]
    get_jqgrid_common("others",accession_ids,exam_status);    
  end
  
  def get_jqgridSearch_exam_data 
    #search can be performed by 2 methods union or intesection
    #if  @Search_buckets_individually value is true then its union else default intersection.
    @Search_buckets_individually = false;
    @employee = Employee.get_employee(session[:username])  
    @myvalues = params[:allSearchCriteriaInJson];
    symbolize_keys_deep! @myvalues;
    
    if ((@myvalues[:search_individual_buckets]== "on" ) ||
          (@myvalues[:search_individual_buckets]== "1" )  || 
          (@myvalues[:search_individual_buckets]== "true" )
      )
      @Search_buckets_individually = true
    end
    
    if (@Search_buckets_individually == true) #its UNION Join
      #perform search on individual  buckets and join the records      
    
      idList = [];
      if ( (@myvalues[:my_reports] == "on") || (@myvalues[:my_exams] == "on") || (@myvalues[:my_orders] == "on"))

        if (@myvalues[:my_reports] == "on")

          @exams1 = Rad_Exam.get_exams_search(@employee.id,@myvalues,true,false,false).pluck(:id) ;        
          if @exams1.length > 0
            #@exams2 = Rad_Exam.get_exams_search(@employee.id,@myvalues,true,false,false).pluck(:id) ; 

            @exams1.each_with_index do |exam, i|                    
              if !(idList.include? exam.to_i)   #exam[:id].to_i                    
                idList << exam.to_i #exam[:id].to_i                
              end     
            end             
          end 
          @exams1 = nil;     
        end   

        if (@myvalues[:my_exams] == "on")

          @exams2 = Rad_Exam.get_exams_search(@employee.id,@myvalues,false,true,false).pluck(:id) ; 
          if @exams2.length > 0
            #@exams2 = Rad_Exam.get_exams_search(@employee.id,@myvalues,false,true,false).pluck(:id) ; 

            @exams2.each_with_index do |exam, i|                    
              if !(idList.include? exam.to_i)   #exam[:id].to_i                    
                idList << exam.to_i #exam[:id].to_i                
              end     
            end             
          end 
          @exams2 = nil;        

        end  #myexams 


        if (@myvalues[:my_orders] == "on")

          @exams3 = Rad_Exam.get_exams_search(@employee.id,@myvalues,false,false,true).pluck(:id) ;    
          if @exams3.length > 0
            #@exams3 = Rad_Exam.get_exams_search(@employee.id,@myvalues,false,false,true).pluck(:id) ; 

            @exams3.each_with_index do |exam, i|                    
              if !(idList.include? exam.to_i)   #exam[:id].to_i                    
                idList << exam.to_i #exam[:id].to_i                
              end     
            end             
          end 
          @exams3 = nil;
        end   

      end   
    
      if( 
          (idList.length > 0) ||  (@myvalues[:my_orders] == "on") || (@myvalues[:my_exams] == "on") || (@myvalues[:my_reports] == "on")
        )        
        @exams = Rad_Exam.get_exams_search_by_id_array(idList);  
      else 
        @exams = Rad_Exam.get_exams_search(@employee.id,@myvalues)  ;    
      end
    else #its  intersection  join NOT UNION Join
      @exams = Rad_Exam.get_exams_search(@employee.id,@myvalues,(@myvalues[:my_orders] == "on"),(@myvalues[:my_exams] == "on"),(@myvalues[:my_reports] == "on"))  ;    
    end
    
    @exams.each do |exam| 
      if ['1037','1027'].include? exam.accession
        exam.graph_status = "cancelled"
        exam.current_status = "cancelled"       
      end
      if '1027' == exam.accession
        exam.graph_status = "cancelled"
        exam.current_status = "cancelled"    
        exam.report_time = "";
      end
        
      if '1017' == exam.accession
        exam.graph_status = "order"
        exam.current_status = "order"    
      end
      if '1015' == exam.accession
        exam.graph_status = "arrived"
        exam.current_status = "arrived"    
      end
      
      exam = get_graph_status(exam);
    end  #end each
    
    #log output data
    log_hipaa_view(@exams);
    
    json_data = {
      :page=>"1",
      :total=>"3",
      :records=>"6", 
      :rows=> JSON.parse(@exams.to_json(:only => [ :accession,:mrn,:current_status,:code,:description,:modality,:resource_name,:graph_status,:current_status,:updated_at,:patient_name,:birthdate,:site_name,:patient_class,:patient_type,:patient_location_at_exam,:radiology_department,:ordering_provider,:scheduler,:technologist,:pacs_image_count,:appt_time,:sign_in,:check_in,:begin_exam,:end_exam]))    
    
    }
    
    respond_to do |format|
      format.json { render :json => json_data }
    end
    
  end
  
  def get_jqgrid_common(roletype,accession,currentstatus)
    #currently this is used to get data for jqgrid_page.
    @employee = Employee.get_employee(session[:username])
    @roleType = roletype
    case roletype
    when "rad"
      @exams = Rad_Exam.get_rad_exams(@employee.id,accession,currentstatus)
    when "tech"
      @exams = Rad_Exam.get_tech_exams(@employee.id,accession,currentstatus)
    when "schedreg"
      @exams = Rad_Exam.get_sched_exams(@employee.id,accession,currentstatus)
    when "trans"
      @exams = Rad_Exam.get_trans_exams(@employee.id,accession,currentstatus)
    when "others"
      @exams = Rad_Exam.get_ordering_exams(@employee.id,accession,currentstatus)
    end
	
    @exams.each do |exam| 
     
      #remove this line after testing
      #<start>
      exam = manipulate_status(exam);
      #<end>
      exam = get_graph_status(exam);    
    
    end  #end each
    
    #log output data
    log_hipaa_view(@exams);
     
    json_data = {
      :page=>"1",
      :total=>"3",
      :records=>"6", 
      :rows=> JSON.parse(@exams.to_json(:only => [ :accession,:mrn,:current_status,:code,:description,:modality,:resource_name,:graph_status,:current_status,:updated_at,:patient_name,:birthdate,:site_name,:patient_class,:patient_type,:patient_location_at_exam,:radiology_department,:ordering_provider,:scheduler,:technologist,:pacs_image_count,:appt_time,:sign_in,:check_in,:begin_exam,:end_exam]))    
    
    }
    
    respond_to do |format|
      format.json { render :json => json_data }
    end
  end  
  
  def get_accession
    @accession_id = params[:accession_id];
    authenticity_token = params[:authenticity_token];      
    @exams = Rad_Exam.get_accession_detail(@accession_id.to_s)   
   
    @exams.each do |exam| 
      #remove this line after testing
      #<start>
      exam = manipulate_status(exam);
      #<end>
      exam = get_graph_status(exam); 
    end
    #@exams.graph_status = exam.graph_status;
    #@exams.graph_status = exam.graph_status;
    #log output data
    log_hipaa_view(@exams);
    if @exams.size > 0
      @exams = @exams[0];
    end
    
    
    respond_to do |format|
      format.json { render :json => @exams.to_json(:only => [ :accession,:mrn,:current_status,:code,:description,:modality,:resource_name,:graph_status,:current_status,:updated_at,:patient_name,:birthdate,:site_name,:patient_class,:trauma,:patient_type,:patient_location_at_exam,:radiology_department,:ordering_provider,:scheduler,:technologist,:pacs_image_count,:appt_time,:sign_in,:check_in,:begin_exam,:end_exam,:first_final,:last_final,:order_arrival,:rad1_name,:rad2_name]) }
    end    
  end
  
  def get_graph_status(exam)
    gstatus = ""
    gstatus = exam.graph_status;
    exam.graph_status="";
    if not( (exam.order_arrival.nil?) || (exam.order_arrival.blank?))         
      exam.graph_status += "order_time->" + exam.order_arrival.to_s + "," 
    else
      exam.graph_status  += "order_time->"  + ","  
    end
      
    if not( (exam.sched_time.nil?) || (exam.sched_time.blank?))         
      exam.graph_status += "sched_time->" + exam.sched_time.to_s + "," 
    else
      exam.graph_status  += "sched_time->"  + ","  
    end
      
    if not( (exam.appt_time.nil?) || (exam.appt_time.blank?))
      exam.graph_status += "appt_time->" + exam.appt_time.to_s + "," 
    else
      exam.graph_status += "appt_time->" +  "," 
    end
    if not( (exam.sign_in.nil?) || (exam.sign_in.blank?))
      exam.graph_status += "sign_in->" + exam.sign_in.to_s + ","
    else
      exam.graph_status += "sign_in->" +  ","
    end  
    if not( (exam.check_in.nil?) || (exam.check_in.blank?))
      exam.graph_status += "check_in->" + exam.check_in.to_s + ","
    else
      exam.graph_status += "check_in->"  + ","
    end  
    if not( (exam.begin_exam.nil?) || (exam.begin_exam.blank?))
      exam.graph_status += "begin_exam->" + exam.begin_exam.to_s + ","
    else
      exam.graph_status += "begin_exam->" + ","
    end  
    if not( (exam.end_exam.nil?) || (exam.end_exam.blank?))
      exam.graph_status += "end_exam->" + exam.end_exam.to_s + ","
    else
      exam.graph_status += "end_exam->" +  ","
    end 
    if not( (exam.report_time.nil?) || (exam.report_time.blank?))
      exam.graph_status += "final_time->" + exam.report_time.to_s + ","
    else
      exam.graph_status += "final_time->" +  ","
    end      
    exam.graph_status += gstatus;
      
    return exam;
  end
  
  def get_accession_report
    @accession_id = params[:accession_id];
    authenticity_token = params[:authenticity_token];      
    @reports = Rad_Exam.get_accession_reports(@accession_id.to_s)    
    
    #log output data
    log_hipaa_view(@reports);
    respond_to do |format|
      format.json { render :json => @reports.to_json(:only => [ :status, :report_time,:report_impression, :report_body, :rad1_name,:rad2_name]) }
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
  
  def manipulate_status(exam)
    
    if ['1037','1027'].include? exam.accession
      exam.graph_status = "cancelled"
      exam.current_status = "cancelled"       
    end
    if '1027' == exam.accession
      exam.graph_status = "cancelled"
      exam.current_status = "cancelled"    
      exam.report_time = "";
    end
        
    if '1017' == exam.accession
      exam.graph_status = "order"
      exam.current_status = "order"    
    end
    if '1015' == exam.accession
      exam.graph_status = "arrived"
      exam.current_status = "arrived"    
    end
    
    return exam;
  end
end
