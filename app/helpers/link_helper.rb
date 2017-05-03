module LinkHelper

  def self.user_show_base(user)
    base = Rails.application.routes.url_helpers.profile_path(user.id)
    random = "&random=" + user.randomized_profile_url
    link = base + random
  end

  def self.next_day(date, user)
    date = "&date=" + (date + 1.days).strftime("%F")
    link = LinkHelper.user_show_base(user) + date
  end

  def self.previous_day(date, user)
    date = "&date=" + (date - 1.days).strftime("%F")
    link = LinkHelper.user_show_base(user) + date
  end

  def self.this_week(date, user)
    week = "&week=" + (date - 7.days).strftime("%F") + '-' + (date).strftime("%F")
    link = LinkHelper.user_show_base(user) + week
  end


  def

  end

end