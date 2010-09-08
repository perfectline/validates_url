require 'active_model/validations'

class UserWithBlank
  include ActiveModel::Validations

  attr_accessor :homepage

  validates :homepage, :url => {:allow_blank => true}
end