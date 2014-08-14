require 'active_model/validations'

class UserWithBlankScheme

  include ActiveModel::Validations

  attr_accessor :homepage

  validates :homepage, :url => {:allow_blank_scheme => true}

end
