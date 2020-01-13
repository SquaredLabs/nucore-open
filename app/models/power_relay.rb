# frozen_string_literal: true

# Including class must implement #relay_connection
module PowerRelay

  extend ActiveSupport::Concern

  MAXIMUM_OUTLETS = 16

  included do
    ## validations
    validates_presence_of :ip, :outlet, :username, :password
    validates :auto_logout_minutes, presence: { if: :auto_logout }
    validates :outlet, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: MAXIMUM_OUTLETS }
    validates :port, numericality: { only_integer: true, greater_than: 0, allow_nil: true }
  end

  ## instance methods
  def control_mechanism
    Relay::CONTROL_MECHANISMS[:relay]
  end

  def connection_options
    options = {}
    options[:username] = username if username.present?
    options[:password] = password if password.present?
    options
  end

  def toggle(status)
    relay_connection.toggle(outlet, status)
  end

  def query_status
    relay_connection.status(outlet)
  end

  def relay_connection
    raise NotImplementedError.new("Subclass must define")
  end

end
