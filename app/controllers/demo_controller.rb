class DemoController < ApplicationController
  before_filter :general_authentication
  before_filter :get_entity_manager
  after_filter :close_entity_manager

  def real_time
  end

  def accession_search
    @exams = []

    if params[:accession]
      @exams = search_by_accession(params[:accession])
      log_hipaa_view(@exams)
      @acc_search = params[:accession]
    end
  end

  private
  def search_by_accession(accession)
    query = Java::HarbingerSdkData::RadExam.createQuery(@em)
    query.where(query.equal(".accession", query.literal(accession))).list.to_a
  end

end
