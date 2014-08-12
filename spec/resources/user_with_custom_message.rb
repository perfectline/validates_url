class UserWithCustomMessage
  include ActiveModel::Validations

  attr_accessor :homepage

  validates :homepage, :url => {message: "wrong"}
end
