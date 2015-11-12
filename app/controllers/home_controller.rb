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
  
  def search_exams(accesession_ids, exam_status)  
  end
  
  def get_jqgrid
  #currently this is used to get data for jqgrid_page.
    json_data = {
   :page=>"1",
   :total=>2,
   :records=>"6", 
   :rows=>[ 
      {:id=>"12345",:status=>{:initialstage=>"current",:patclass=>"current",:appttime=>"current",:scheduledstop=>""},:MRN=>"Desktop Computers",:procdescription=>"CT Scan for Needle blopsy",:signin=>"10-11-2015"}, 
      {:id=>"23456",:status=>{:initialstage=>"current",:patclass=>"current",:appttime=>"red",:scheduledstop=>""},:MRN=>"laptop",:procdescription=>"CT Scan for Needle blopsy",:signin=>"09-11-2015"},
      {:id=>"34567",:status=>{:initialstage=>"current",:patclass=>"current",:appttime=>"current",:scheduledstop=>""},:MRN=>"LCD Monitor",:procdescription=>"CT Scan for Needle blopsy",:signin=>"10-12-2015"},
      {:id=>"34567",:status=>{:initialstage=>"current",:patclass=>"current",:appttime=>"current",:scheduledstop=>""},:MRN=>"TFT Monitor",:procdescription=>"CT Scan for Needle blopsy",:signin=>"22-08-2014"},
      {:id=>"34567",:status=>{:initialstage=>"current",:patclass=>"current",:appttime=>"current",:scheduledstop=>"green"},:MRN=>"LCD Monitor",:procdescription=>"CT Scan for Needle blopsy",:signin=>"10-11-2015"},
      {:id=>"45678",:status=>{:initialstage=>"current",:patclass=>"current",:appttime=>"current",:scheduledstop=>""},:MRN=>"Speakers",:procdescription=>"CT Scan for Needle blopsy",:signin=>"10-11-2014"} 
    ] 
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
