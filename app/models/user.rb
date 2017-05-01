class User < ApplicationRecord
  has_many :meals
  has_many :messages

  before_save :generate_randomized_profile_url

  def generate_randomized_profile_url
    self.randomized_profile_url = "THIS IS A URL"
  end



end
