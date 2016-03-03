class PicturesController < ApplicationController                                                                                                                                                                                                                               
	  before_filter :general_authentication
	  before_filter :get_entity_manager
	  after_filter :close_entity_manager
	
	  def show
	    id = params["id"].to_i
	    employee = Java::HarbingerSdkData::Employee.withId(id)
	
	    if employee && ! employee.demographicHash["photo"].blank?
	      matches = employee.demographicHash["photo"].match(/\Adata:(.*);base64,(.*)\z/m)
	      send_data Base64.decode64(matches[2]), type: matches[1], disposition: 'inline'
	    else
	      render nothing: true
	    end 
	  end 
	end