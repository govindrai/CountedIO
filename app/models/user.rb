class User < ApplicationRecord
  has_many :meals
  has_many :messages

  before_save :generate_randomized_profile_url

  def generate_randomized_profile_url
    random = %w(a b c d e f g h i j k l m n o p q r s t u v w y z A B C D E F G H I J K L M N O P Q R S T U V W Y Z 1 2 3 4 5 6 7 8 9)

    base_url = "https://vildeio.herokuapp.com/profile/#{self.id}?random="
    random_url = ''
    10.times {|time| random_url += random.sample }
    self.randomized_profile_url = base_url + random_url
  end



end
