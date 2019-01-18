class UserWithArLegacy < ActiveRecord::Base
  self.table_name = "users"

  validates_url :homepage
end
