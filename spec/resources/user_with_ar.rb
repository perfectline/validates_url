class UserWithAr < ActiveRecord::Base
  self.table_name = "users"

  validates :homepage, :url => true
end