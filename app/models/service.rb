class Service < Product
  has_many :service_price_policies, :foreign_key => :product_id
  has_many :external_service_passers, :as => :passer
  has_many :external_services, :through => :external_service_passers

  def active_survey
    active=external_service_passers.find(
            :first,
            :joins => 'INNER JOIN external_services ON external_services.id=external_service_id',
            :conditions => [ 'active = 1 AND external_services.type = ?', ExternalServiceManager.survey_service.name ]
    )

    active ? active.external_service : nil
  end

  # returns true if there is at least 1 active survey; false otherwise
  def active_survey?
    !self.active_survey.blank?
  end

  # returns true if there is an active template... false otherwise
  def active_template?
    self.file_uploads.template.count > 0
  end

end
