require 'active_model/validations'

class UserWithNil
  include ActiveModel::Validations

  attr_accessor :homepage

  validates :homepage, :url => {:allow_nil => true}
end