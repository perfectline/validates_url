class User
  include ActiveModel::Validations

  attr_accessor :homepage

  validates :homepage, :url => true
end