class UserWithArAndSns < ActiveRecord::Base
  self.table_name = "users"

  validates :homepage, :sns_uri => true
end
