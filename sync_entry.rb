require "securerandom"
require "google_calendar"
require "dm-core"
require "dm-migrations"
require "dm-validations"
require "uri"
require "./firmafon"

module FirmafonGcalSync
  class SyncEntry
    include DataMapper::Resource

    property :id, Serial
    property :firmafon_user_key, String, length: 128
    property :google_email, String
    property :google_password, String
    property :google_app_name, String
    property :token, String

    attr_accessor :firmafon_email, :firmafon_password

    validates_with_method :validate_google_credentials
    validates_with_method :validate_firmafon_user_key

    before :valid?, :set_firmafon_user_key
    before :create, :set_token

    def busy?
      calendar.find_events_in_range(Time.now, Time.now+1) != nil
    end

    def do_not_disturb
      firmafon_client.employee(firmafon_user_key)["do_not_disturb"]
    end

    def do_not_disturb=(value)
      firmafon_client.set_employee(firmafon_user_key, do_not_disturb: value)
    end

    protected

    def calendar
      Google::Calendar.new(
        username: google_email,
        password: google_password,
        app_name: google_app_name
      )
    end

    def firmafon_client
      Firmafon::Client.new(FIRMAFON_APP_KEY)
    end

    def set_token
      self.token = SecureRandom.urlsafe_base64
    end

    def set_firmafon_user_key
      self.firmafon_user_key ||= firmafon_client.user_key(firmafon_email, firmafon_password)["token"] rescue nil
    end

    def validate_google_credentials
      calendar rescue [false, "Google email, kodeord eller app navn er ikke korrekte"]
    end

    def validate_firmafon_user_key
      firmafon_client.employee(firmafon_user_key) rescue [false, "Firmafon brugernavn eller kodeord er ikke korrekte"]
    end
  end
end
