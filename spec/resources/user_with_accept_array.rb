require 'active_model/validations'

class UserWithAcceptArray
  include ActiveModel::Validations

  attr_accessor :homepage

  validates :homepage, url: { accept_array: true }
end
