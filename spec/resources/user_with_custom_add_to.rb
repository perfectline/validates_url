class UserWithCustomAddTo
  include ActiveModel::Validations

  attr_accessor :homepage

  validates :homepage, :url => {add_to: :base}
end
