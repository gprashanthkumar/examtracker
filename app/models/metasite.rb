class Metasite < ActiveRecord::Base
  self.table_name = "public.metasites"

  has_many :external_systems

  extend LoadingMixin

end
