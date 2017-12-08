require 'active_model/validations'

class UserWithLegacySyntax
  include ActiveModel::Validations

  attr_accessor :homepage

  validates_url :homepage, allow_blank: true
end
