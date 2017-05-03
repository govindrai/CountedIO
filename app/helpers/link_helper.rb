module LinkHelper

  def self.next_day(date, user)
    base = Rails.application.routes.url_helpers.profile_path(user.id)
    random = "&random=" + user.randomized_profile_url
    date = "&date=" + (date + 1.days).strftime("%F")
  end

  def
end