module LoadingMixin

  def ios(field_value_hash)
    x = self.where(field_value_hash).first
    if x
      x
    else
      self.create(field_value_hash)
    end
  end

  def standard_date(date)
    if not date.blank?
      if /\d{2}-\d{2}-\d{4}/.match(date)
        Time.strptime(date,"%m-%d-%Y")
      elsif /\d{4}-\d{2}-\d{2}/.match(date)
        Time.strptime(date,"%Y-%m-%d")
      end
    else
      nil
    end
  end

end
