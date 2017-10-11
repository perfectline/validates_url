require 'active_model/validations'

class UserWithBlacklistedDomains
  include ActiveModel::Validations

  attr_accessor :homepage

  validates :homepage, :url => {:blacklisted_domains => ['example.net']}
end
