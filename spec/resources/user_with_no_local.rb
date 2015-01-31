require 'active_model/validations'

class UserWithNoLocal
  include ActiveModel::Validations

  attr_accessor :homepage

  validates :homepage, :url => {:no_local => true}
end