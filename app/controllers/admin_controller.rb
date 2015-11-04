class AdminController < ApplicationController
  before_filter :admin_authentication
  before_filter :get_entity_manager
  after_filter :close_entity_manager

  def index
  end
end
