class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :get_entity_manager
  before_filter :set_web_analytics_tracker
  after_filter :close_entity_manager

  def get_entity_manager
    @entity_manager ||= Java::HarbingerSdk::DataUtils.getEntityManager
  end

  def close_entity_manager
    @entity_manager.close if !@entity_manager.nil?
  end

  def set_web_analytics_tracker
    begin
      properties = javax.naming.InitialContext.new.lookup("harbinger-wa-config")
      @web_analytics_tracker = properties.getProperty("vanilla-app") || ""
    rescue NativeException => e
      @web_analytics_tracker = ""
    end
  end

  def general_authentication
    authenticate()
  end

  def admin_authentication
    authenticate_and_authorize(["ai-staff","it-staff"])
  end

  def log_hipaa_view(objects,options={})
    if objects.size > 0
      options.reverse_merge!({
          :app_name => "ai-vanilla-app",
          :request_info => request.original_fullpath,
          :requesting_ip => request.remote_ip,
          :table_name => objects.first.class.table_name,
          :username => session[:username],
          :domain => session[:domain] || "not set in session",
          :table_ids => objects.collect {|exam| exam.id }
        })
      objects.compact! if objects.class == Array
      Java::HarbingerSdk::Hipaa.explicit_logger(
                                         options[:app_name],
                                         options[:request_info],
                                         options[:requesting_ip],
                                         options[:username],
                                         options[:domain],
                                         options[:table_name],
                                         options[:table_ids])
    end
  end

end
