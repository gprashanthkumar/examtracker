module Bridge

  def self.app_token
    token = Java::HarbingerSdkData::AppAuthenticationToken.firstWith({".appName" => "emocha"})
    token.auth_token
  end

  def self.account_host
    Java::HarbingerSdkData::ConfigurationVariable.firstWith({".configurationKey" => "global-account-host"}).configurationValue
  end

  def self.data_manager_host
    Java::HarbingerSdkData::ConfigurationVariable.firstWith({".configurationKey" => "data-manager-host"}).configurationValue
  end

  def self.default_state
    Java::HarbingerSdkData::ConfigurationVariable.firstWith({".configurationKey" => "default-state"}).try(:configurationValue) || ""
  end

  def self.login_information
    vars = Java::HarbingerSdkData::ConfigurationVariable.allWithLimit(1000)
    vars.to_a.inject({}) {|hash,cv| hash[cv.configurationKey] = cv.configurationValue if cv.configurationKey =~ /^login\-/; hash }
  end

  
 end
 #End of module
 