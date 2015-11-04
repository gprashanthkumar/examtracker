# HarbingerSsoLogin
module HarbingerRailsExtensions
  module ControllerMethods

    def get_token_cookie(token_cookie_name)
      token_cookie =
        CGI.unescape(request.cookies.fetch(token_cookie_name, nil).
            to_s.gsub('+', '%2B'))
      token_cookie != '' ? token_cookie : nil
    end

    def get_cookie_name_for_token
      Java::harbinger.sdk.SSO.get_cookie_name
    end

    def authenticate_and_authorize(groups=[],entity_manager=nil)
      authenticate_and_authorize_with(:any_authorized?,groups,entity_manager)
    end

    def authenticate_and_any_authorize(groups=[],entity_manager=nil)
      authenticate_and_authorize_with(:any_authorized?,groups,entity_manager)
    end

    def authenticate_and_all_authorize(groups=[],entity_manager=nil)
      authenticate_and_authorize_with(:all_authorized?,groups,entity_manager)
    end

    def authenticate_and_authorize_with(auth_method,groups = [],entity_manager=nil)
      authed = authenticate()
      if authed and self.send(auth_method,groups,entity_manager)
        return true
      elsif authed
        redirect_to :controller => :unauthorized, :action => :index
        return false
      else
        return false
      end
    end

    def authenticate()
      token_cookie_name = get_cookie_name_for_token
      token_cookie = get_token_cookie(token_cookie_name)
      valid_token_test = Java::harbinger.sdk.SSO.valid_token(token_cookie)

      if valid_token_test
        session[:is_authenticated] = true
        session[:username] = Java::harbinger.sdk.SSO.attributes(token_cookie)["uid"][0]
        session[:domain] = Java::harbinger.sdk.SSO.getDomain(token_cookie)
        return true
      else
        session[:is_authenticated] = nil
        session[:domain] = nil
        redirect_to Java::harbinger.sdk.SSO.get_redirect_url(request.url)
        return false
      end
    end

    #Checks the authority of the group
    def authorized?(groups,entity_manager=nil)
      any_authorized?(groups,entity_manager)
    end

    def any_authorized?(groups,entity_manager=nil)
      authorize_with(:authorizedForAny,groups,entity_manager)
    end

    def all_authorized?(groups,entity_manager=nil)
      authorize_with(:authorizedForAll,groups,entity_manager)
    end

    def authorize_with(method,groups,entity_manager)
      if groups == []
        return true
      else
        employee = Java::HarbingerSdkData::Employee.withUserName(session[:username],entity_manager)
        if employee
          return employee.send(method,groups)
        else
          return false
        end
      end
    end

  end

  module Helpers
    def authorized(groups, &block)
      any_authorized(groups, &block)
    end

    def any_authorized(groups, &block)
      groups.class == Array ? groups : groups = [groups]
      if any_authorized?(groups)
        concat(capture(&block))
      else
        nil
      end
    end

    def all_authorized(groups, &block)
      groups.class == Array ? groups : groups = [groups]
      if all_authorized?(groups)
        concat(capture(&block))
      else
        nil
      end
    end

  end
end
