class UserWithCustomScheme
  include ActiveModel::Validations

  attr_accessor :homepage

  validates :homepage, url: { schemes: ['ftp'] }
end
