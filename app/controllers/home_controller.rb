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
  
  def experiment
    @employee = Employee.get_employee(session[:username])
    #json_text = [{"aaData"=>{:Id =>"Ashish Kumar", :MRN => "7842141835", :ProcDescription=>"aasfsdfsdf"}}].to_json
    #arary_text = [{"aaData"=>{:Id =>"Ashish Kumar", :MRN => "7842141835", :ProcDescription=>"aasfsdfsdf"}}].to_a
    #puts array_text
  end
  
  def jqgrid_page  
    @employee = Employee.get_employee(session[:username])
  end
  
  def search_exams
    accession_ids = params[:accession_ids]
    exam_status = params[:exam_status]
    json_data = {:aaData=> [["1","10516","CT Scan"],["sdf","adsdf","sadfsd"],["sdf","adsdf","sadfsd"]]}.to_json
    respond_to do |format|
     format.json { render :json => json_data }
    end
  end
  
  def get_jqgrid
	#currently this is used to get data for jqgrid_page.
	@employee = Employee.get_employee(session[:username])   
	@exams = Rad_Exam.get_rad_exams(@employee)
  
    
     
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
  
  def get_jqgridRad
	accession_ids = params[:accession]
  exam_status = params[:status]
	
    get_jqgrid_common("rad",accession_ids,exam_status);
    puts "its in get_jqgridRad"
  end
  
  def get_jqgridTech
    accession_ids = params[:accession]
    exam_status = params[:status]
  
    get_jqgrid_common("tech",accession_ids,exam_status);
     puts "its in get_jqgridTech"
  end
  
  def get_jqgridScheReg
    accession_ids = params[:accession]
  exam_status = params[:status]
    get_jqgrid_common("schedreg",accession_ids,exam_status);
     puts "its in get_jqgridScheReg"
  end
  
  def get_jqgridTranscript
    accession_ids = params[:accession]
  exam_status = params[:status]
    get_jqgrid_common("trans",accession_ids,exam_status);
     puts "its in get_jqgridTranscript"
  end
    
  def get_jqgridOthers
    accession_ids = params[:accession]
  exam_status = params[:status]
    get_jqgrid_common("others",accession_ids,exam_status);
     puts "its in get_jqgridOthers"
  end
  
  def get_jqgridSearch_exam_data 
    @employee = Employee.get_employee(session[:username])  
    @opts = params;
    if (@opts.nil? || @opts.empty?)
      puts "@opts is empty"
    end
    
    #symbolize_keys_deep! @opts
    
    @exams = Rad_Exam.get_exams_search(@employee.id,params[:mrn])  
    puts "its in get_jqgridSearch_exam_data" 
   
    
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
     @exams = Rad_Exam.get_other_exams(@employee.id,accession,currentstatus)
  end
	
     @exams.each do |exam| 
       gstatus = ""
       gstatus = exam.graph_status;
       exam.graph_status  = "order_time-> "  + ","  
       exam.graph_status = exam.graph_status + "sched_time->"  + "," 
      if not( (exam.appt_time.nil?) || (exam.appt_time.blank?))
        exam.graph_status = exam.graph_status + "appt_time->" + exam.appt_time.to_s + "," 
      end
      if not( (exam.sign_in.nil?) || (exam.sign_in.blank?))
        exam.graph_status = exam.graph_status + "sign_in->" + exam.sign_in.to_s + ","
      end      
      
#       exam.graph_status = exam.graph_status + "check_in->" + exam.check_in + ","
#       exam.graph_status = exam.graph_status + "begin_exam->" + exam.begin_exam + ","
#       exam.graph_status = exam.graph_status + "end_exam->" + exam.end_exam + ","
     end 
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
  
  def get_jqgrid_data
    #working code for jqgrid
    json_data = {
      :total =>1,
      :page =>1,
      :records =>1,
      :rows => [
          {:cell => ["101", "7842141835"]},
          {:cell => ["102", "10816"]}
        ]
      }.to_json
    respond_to do |format|
     format.json { render :json => json_data }
    end
  end
  
  def get_data
    json_data = {:aaData=> [["1","10516","CT Scan"],["sdf","adsdf","sadfsd"],["sdf","adsdf","sadfsd"]]}.to_json
    respond_to do |format|
     format.json { render :json => json_data }
    end
  end
  
  def get_data1
    json_data = {:aaData=> [["sdf","adsdf","sadfsd"],["sdf","adsdf","sadfsd"],["sdf","adsdf","sadfsd"]]}.to_json
    respond_to do |format|
     format.json { render :json => json_data }
    end
  end
  
  def logout
    reset_session
    @employee = nil   
    redirect_to Java::HarbingerSdk::SSO.logoutUrl()
    
  end
  
  def get_accession
     @accession_id = params[:accession_id];
     authenticity_token = params[:authenticity_token];      
     @exams = Rad_Exam.get_accession_detail(@accession_id.to_s)
     #puts @exams.to_json;
    respond_to do |format|
      format.json { render :json => @exams.to_json(:only => [ :accession,:mrn,:current_status,:code,:description,:modality,:resource_name,:graph_status,:current_status,:updated_at,:patient_name,:birthdate,:site_name,:patient_class,:trauma,:patient_type,:patient_location_at_exam,:radiology_department,:ordering_provider,:scheduler,:technologist,:pacs_image_count,:appt_time,:sign_in,:check_in,:begin_exam,:end_exam,:first_final,:last_final,:order_arrival]) }
    end    
  end
  
   def get_accession_report
     @accession_id = params[:accession_id];
     authenticity_token = params[:authenticity_token];      
     @reports = Rad_Exam.get_accession_reports(@accession_id.to_s)
     #puts @exams.to_json;
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
end
