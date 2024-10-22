require 'active_model/validations'

class UserWithAcceptArrayWithMessage
  include ActiveModel::Validations

  attr_accessor :homepage

  validates :homepage, url: { accept_array: true, message: 'wrong' }
end
