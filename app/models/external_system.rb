class ExternalSystem < ActiveRecord::Base
  self.table_name = "public.external_systems"

  belongs_to :metasite

  extend LoadingMixin

  def self.emocha(em=nil)
    q = Java::HarbingerSdkData::ExternalSystem.createQuery(em)
    q.where([q.equal(".externalSystem","Emocha"),
              q.equal(".metasite.metasite","Emocha")]).first
  end

  def self.others(em=nil)
    q = Java::HarbingerSdkData::ExternalSystem.createQuery(em)
    q.where([q.notEqual(q.upper(".externalSystem"),"emocha".upcase),
              q.notEqual(q.upper(".externalSystem"),"active directory".upcase)]).list.to_a
  end

end
