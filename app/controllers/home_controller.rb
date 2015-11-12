class HomeController < ApplicationController
  before_filter :general_authentication
  before_filter :get_entity_manager
  after_filter :close_entity_manager
  layout 'examtracker_layout'
  
    
  def radiologist
  end
  
  def technologist
  end
  
  def sche_registrar
  end
  
  def transcript
  end
  
  def others
  end
  
  def search
  end
  
  def experiment
    #json_text = [{"aaData"=>{:Id =>"Ashish Kumar", :MRN => "7842141835", :ProcDescription=>"aasfsdfsdf"}}].to_json
    #arary_text = [{"aaData"=>{:Id =>"Ashish Kumar", :MRN => "7842141835", :ProcDescription=>"aasfsdfsdf"}}].to_a
    #puts array_text
  end
  
  def jqgrid_page   
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
		:total=>3,
		:records=>"6", 
		:rows=> JSON.parse(@exams.to_json(:only => [ :accession,:mrn,:code,:description ])) 
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

end
