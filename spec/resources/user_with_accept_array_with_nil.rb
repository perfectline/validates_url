require 'active_model/validations'

class UserWithAcceptArrayWithNil
  include ActiveModel::Validations

  attr_accessor :homepage

  validates :homepage, url: { accept_array: true, allow_nil: true }
end
