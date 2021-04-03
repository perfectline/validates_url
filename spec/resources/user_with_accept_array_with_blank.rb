require 'active_model/validations'

class UserWithAcceptArrayWithBlank
  include ActiveModel::Validations

  attr_accessor :homepage

  validates :homepage, url: { accept_array: true, allow_blank: true}
end
