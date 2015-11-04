class MainController < ApplicationController
  before_filter :general_authentication
  before_filter :get_entity_manager
  after_filter :close_entity_manager

  def index
  end

  def help
  end

  def about
  end

end
