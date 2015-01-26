require 'active_model/validations'

class UserWithPublicSuffix
  include ActiveModel::Validations

  attr_accessor :homepage

  validates :homepage, :url => {:public_suffix => true}
end
