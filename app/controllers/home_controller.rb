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
	
    get_jqgrid_common("rad",accession_ids);
    puts "its in get_jqgridRad"
  end
  
  def get_jqgridTech
    get_jqgrid_common("tech","");
     puts "its in get_jqgridTech"
  end
  
  def get_jqgridScheReg
    get_jqgrid_common("schedreg","");
     puts "its in get_jqgridScheReg"
  end
  
  def get_jqgridTranscript
    get_jqgrid_common("trans","");
     puts "its in get_jqgridTranscript"
  end
    
  def get_jqgridOthers
    get_jqgrid_common("others","");
     puts "its in get_jqgridOthers"
  end
  
  def get_jqgridSearch_exam_data 
    search_criteriaJSON = params[:allSearchCriteriaInJson]
    puts "Visit#: "+search_criteriaJSON['visit']
	
    @employee = Employee.get_employee(session[:username])   
    @exams = Rad_Exam.get_exams_all(@employee.id)  
	  
    get_jqgrid_common("rad","");
    puts "its in get_jqgridRad"
  end
  
  def get_jqgrid_common(roletype,accession)
    
    puts "prashanth " + accession.to_s;
  end
	#currently this is used to get data for jqgrid_page.
	@employee = Employee.get_employee(session[:username])
  @roleType = roletype
  case roletype
  when "rad"
    @exams = Rad_Exam.get_rad_exams(@employee.id,accession,"")
    when "tech"
    @exams = Rad_Exam.get_tech_exams(@employee.id)
  when "schedreg"
     @exams = Rad_Exam.get_sched_exams(@employee.id) 
  when "trans"
     @exams = Rad_Exam.get_trans_exams(@employee.id)   
  when "others"
     @exams = Rad_Exam.get_other_exams(@employee.id)
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
      format.json { render :json => @exams.to_json(:only => [ :accession,:mrn,:current_status,:code,:description,:modality,:resource_name,:graph_status,:current_status,:updated_at,:patient_name,:birthdate,:site_name,:patient_class,:trauma,:patient_type,:patient_location_at_exam,:radiology_department,:ordering_provider,:scheduler,:technologist,:pacs_image_count,:appt_time,:sign_in,:check_in,:begin_exam,:end_exam,:first_final,:last_final]) }
    end    
  end
  
  

end
